use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tools_challenge, ToolsChallenge.Repo,
  database: "tools_challenge_test",
  hostname: "localhost"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tools_challenge, ToolsChallengeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :tools_challenge, ToolsChallenge.Elasticsearch, index: "app_test"

config :tools_challenge, :mailer_url, "http://127.0.0.1:4444/mailer"
