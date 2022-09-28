defmodule Cap.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Cap.Repo,
      # Start the Telemetry supervisor
      CapWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cap.PubSub},
      # Start the Endpoint (http/https)
      CapWeb.Endpoint,
      Cap.PublisherPool,
      Cap.CountersPipeline
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CapWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
