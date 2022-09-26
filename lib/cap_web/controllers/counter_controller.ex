defmodule CapWeb.CounterController do
  use CapWeb, :controller

  alias Ecto.Changeset
  alias Cap.CountersPipeline

  @increment_schema %{key: :string, value: :integer}

  def increment(conn, params) do
    with {:ok, request} <- sanitize(params),
         :ok <- CountersPipeline.enqueue(request.key, request.value) do
      conn
      |> put_status(:accepted)
      |> text("")
    else
      {:error, :invalid_request_format} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "invalid request format"})

      e ->
        e
    end
  end

  defp sanitize(params) do
    params
    |> validate()
    |> parse()
  end

  defp validate(params) do
    schema_keys = Map.keys(@increment_schema)

    {%{}, @increment_schema}
    |> Changeset.cast(params, schema_keys)
    |> Changeset.validate_required(schema_keys)
  end

  defp parse(%Changeset{valid?: true, changes: changes}) do
    {:ok, changes}
  end

  defp parse(%Changeset{valid?: false}), do: {:error, :invalid_request_format}
end
