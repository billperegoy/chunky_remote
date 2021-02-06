use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :chunky_remote, ChunkyRemote.Repo,
  username: "postgres",
  password: "postgres",
  database: "chunky_remote_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chunky_remote, ChunkyRemoteWeb.Endpoint,
  http: [port: 4002],
  server: true

config :chunky_remote, ChunkyRemote.Mailer, adapter: Bamboo.TestAdapter

# Wallaby
config :wallaby, driver: Wallaby.Chrome

config :wallaby,
  chromedriver: [
    path: "assets/node_modules/chromedriver/bin/chromedriver"
  ]

config :wallaby, otp_app: :chunky_remote

config :chunky_remote, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn
