defmodule Cap.Counters do
  @moduledoc """
  The Counters context.
  """

  import Ecto.Query, warn: false
  alias Cap.Repo

  alias Cap.Counters.Counter

  @doc """
  Receives a list of increment request and upates in the database.
  This function considers that many increments for the same key may
  be provided so it groups them and updates only once.

  increment format: %{key: "anykey", value: 1234}
  """
  def process_many(increments) do
    increments
    |> Enum.group_by(& &1.key)
    |> Enum.map(&sum_increments/1)
    |> upsert_many()
  end

  def upsert_many(increments) do
    upsert_query =
      Counter
      |> where([c], c.key == fragment("EXCLUDED.key"))
      |> update(inc: [value: fragment("EXCLUDED.value")])

    increments
    |> Enum.map(&change_counter(%Counter{}, &1))
    |> Enum.map(& &1.changes)
    |> then(
      &Repo.insert_all(Counter, &1,
        on_conflict: upsert_query,
        conflict_target: [:key],
        returning: false
      )
    )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking count changes.

  ## Examples

      iex> change_counter(counter)
      %Ecto.Changeset{data: %Counter{}}

  """
  def change_counter(%Counter{} = counter, attrs \\ %{}) do
    Counter.changeset(counter, attrs)
  end

  defp sum_increments({key, increments}) do
    increments
    |> Enum.reduce(0, &(&2 + &1.value))
    |> then(&%{key: key, value: &1})
  end
end
