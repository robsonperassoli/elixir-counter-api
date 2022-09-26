defmodule Cap.CountersPipelineTest do
  use Cap.DataCase, async: true

  test "batch executes on timeout even when less than 500 messages" do
    batch = 1..10 |> Enum.map(&Cap.CountersPipeline.new_message("errors", &1))
    ref = Broadway.test_batch(Cap.CountersPipeline, batch, metadata: %{ecto_sandbox: self()})

    assert_receive {:ack, ^ref, produced_batch, []}, 3000
    assert length(produced_batch) == 10
  end

  test "batch executes right after 500 messages arive" do
    batch = 1..501 |> Enum.map(&Cap.CountersPipeline.new_message("errors", &1))
    ref = Broadway.test_batch(Cap.CountersPipeline, batch, metadata: %{ecto_sandbox: self()})

    assert_receive {:ack, ^ref, produced_batch, []}
    assert length(produced_batch) == 500
  end
end
