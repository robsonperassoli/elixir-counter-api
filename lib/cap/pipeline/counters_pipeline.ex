defmodule Cap.CountersPipeline do
  use Broadway

  @separator ">.<"
  @batch_size 500
  @producer_queue_name "counters_queue"

  def start_link(_args) do
    producer = Application.fetch_env!(:cap, :counter_pipeline_producer)

    options = [
      name: __MODULE__,
      producer: [
        module: producer,
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 1]
      ],
      batchers: [
        default: [batch_size: @batch_size, batch_timeout: 6_000]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  def handle_message(_processor, message, _context) do
    message
  end

  def handle_batch(_batcher, messages, _batch_info, _context) do
    messages
    |> Enum.map(&to_map/1)
    |> Cap.Counters.process_many()

    messages
  end

  def enqueue(key, value) when is_binary(key) and is_integer(value) do
    # with {:ok, chan} <- AMQP.Application.get_channel(:default) do
    #   AMQP.Basic.publish(chan, "", @producer_queue_name, new_message(key, value))
    # end

    ExRabbitPool.with_channel(:publisher_pool, fn {:ok, channel} ->
      AMQP.Basic.publish(channel, "", @producer_queue_name, new_message(key, value))
    end)
  end

  def enqueue(_, _), do: {:error, :invalid_values}

  def new_message(key, value), do: "#{key}#{@separator}#{value}"

  defp to_map(%Broadway.Message{data: data}) do
    [key, value] = String.split(data, @separator)

    %{key: key, value: String.to_integer(value)}
  end
end
