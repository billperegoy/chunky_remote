# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chunky_remote,
  ecto_repos: [ChunkyRemote.Repo]

# Configures the endpoint
config :chunky_remote, ChunkyRemoteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eMw114+L0BkGE/zysl7KFS6MdYU5UZ7zN7Qle/QRy0WjuJIx46jZhEHnWSTTgkXg",
  render_errors: [view: ChunkyRemoteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ChunkyRemote.PubSub,
  live_view: [signing_salt: "UKr5Ld4a"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :event_bus, topics: [:user_created]

config :chunky_remote, ChunkyRemote.Mailer, adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
