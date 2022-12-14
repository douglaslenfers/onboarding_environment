defmodule MailerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mailer

  @session_options [
    store: :cookie,
    key: "_mailer_key",
    signing_salt: "HyFcrR/g"
  ]

  socket "/socket", MailerWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :mailer,
    gzip: false,
    only: ~w(css js)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug MailerWeb.Router
end
