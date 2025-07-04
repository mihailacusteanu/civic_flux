import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :civic_flux, CivicFluxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Q/Y9IioNrrwwxIRf7xVQ9RXtMMFR82BzSquJheGKY10Y6dIab+TlibYE5bw0YFD5",
  server: false

# In test we don't send emails
config :civic_flux, CivicFlux.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :civic_flux, CivicFlux.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "civic_flux_eventstore_test",
  hostname: "localhost",
  pool_size: 1

config :civic_flux, CivicFlux.Repo,
  username: "postgres",
  password: "postgres",
  database: "civic_flux_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
