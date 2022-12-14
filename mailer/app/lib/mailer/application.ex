defmodule Mailer.Application do
  use Application

  def start(_type, _args) do
    children = [
      MailerWeb.Telemetry,
      {Phoenix.PubSub, name: Mailer.PubSub},
      MailerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Mailer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MailerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
