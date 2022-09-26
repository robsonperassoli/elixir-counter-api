defmodule Cap.Counters.Counter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:key, :string, autogenerate: false}
  schema "counters" do
    field :value, :integer, default: 0
  end

  @doc false
  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> unique_constraint(:key)
  end
end
