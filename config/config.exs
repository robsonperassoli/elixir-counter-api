# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cap,
  ecto_repos: [Cap.Repo]

# Configures the endpoint
config :cap, CapWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CapWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Cap.PubSub,
  live_view: [signing_salt: "bz7tYf3j"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :amqp,
  connections: [
    default: [url: nil]
  ],
  channels: [
    default: [connection: :default]
  ]

config :cap, :counter_pipeline_producer, {
  BroadwayRabbitMQ.Producer,
  [
    queue: "counters_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue,
    qos: [prefetch_count: 500]
  ]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
