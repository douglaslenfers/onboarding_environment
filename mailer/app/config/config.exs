# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :mailer, MailerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Y4C4z2zElNjOF2r6GhzNID0Bw8dokEmzJ0C5mvegvwrlGp+KMapuoq75kGVUfact",
  render_errors: [view: MailerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mailer.PubSub,
  live_view: [signing_salt: "TmGqHA3k"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mailer, Mailer.Mailer, adapter: Bamboo.LocalAdapter

config :phoenix, :json_library, Jason
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
