defmodule ToolsChallengeWeb.PageController do
  use ToolsChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
