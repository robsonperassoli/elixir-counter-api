defmodule Cap.Repo do
  use Ecto.Repo,
    otp_app: :cap,
    adapter: Ecto.Adapters.Postgres
end
