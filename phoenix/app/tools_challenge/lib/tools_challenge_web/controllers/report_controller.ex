defmodule ToolsChallengeWeb.ReportController do
  use ToolsChallengeWeb, :controller

  alias ToolsChallenge.Services.Report

  def index(conn, _params) do
    case Report.request_report("products_report") do
      {:ok, report_data} -> send_resp(conn, 202, report_data)
      {:not_yet, message} -> send_resp(conn, 202, message)
      {:error, error} -> send_resp(conn, 500, "")
    end
  end
end
