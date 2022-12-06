defmodule ToolsChallengeWeb.Router do
  use ToolsChallengeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ToolsChallengeWeb do
    pipe_through :browser

    get "/", ProductController, :index
    resources "/products", ProductController
    get "/report", ReportController, :get_report
    post "/report", ReportController, :equeue_report
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ToolsChallengeWeb.Telemetry
    end
  end
end
