import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cap, Cap.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cap_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cap, CapWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9ftfTuM6PHjDhDBQA0UOrt7PevHQeA420ut16veEXTaNkXigcm2DFQ3vk5kFuVRV",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :cap, :counter_pipeline_producer, {Broadway.DummyProducer, []}
