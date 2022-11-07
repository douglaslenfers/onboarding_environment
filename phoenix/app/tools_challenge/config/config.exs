# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tools_challenge,
  ecto_repos: [ToolsChallenge.Repo]

config :tools_challenge, Repo,
  adapter: Mongo.Ecto,
  database: "tools_challenge",
  hostname: "localhost"

# Configures the endpoint
config :tools_challenge, ToolsChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L4C4z2zElNjOF2r6GhzNID0Bw8dokEmzJ0C5mvegvwrlGp+KMapuoq75kGVUfact",
  render_errors: [view: ToolsChallengeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ToolsChallenge.PubSub,
  live_view: [signing_salt: "LmGqHA3k"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
