defmodule Cap.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters, primary_key: false) do
      add :key, :string, null: false, primary_key: true
      add :value, :integer, null: false, default: 0
    end
  end
end
