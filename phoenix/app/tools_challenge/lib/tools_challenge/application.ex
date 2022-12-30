defmodule ToolsChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      supervisor(ToolsChallenge.Repo, []),
      # Start the Telemetry supervisor
      ToolsChallengeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ToolsChallenge.PubSub},
      # Start the Endpoint (http/https)
      ToolsChallengeWeb.Endpoint,
      # Start Redis Server Supervisor
      ToolsChallenge.Cache.RedisSupervisor
    ]

    Logger.add_backend(Sentry.LoggerBackend)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ToolsChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ToolsChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
