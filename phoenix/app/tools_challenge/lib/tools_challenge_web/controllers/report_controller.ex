defmodule ToolsChallengeWeb.ReportController do
  use ToolsChallengeWeb, :controller

  alias ToolsChallenge.Services.CsvExport
  alias ToolsChallenge.Jobs.ReportJob

  def get_report(conn, _params) do
    send_download(conn, {:file, CsvExport.get_path()})
  end

  def equeue_report(conn, _params) do
    case ReportJob.equeue() do
      :ok -> send_resp(conn, 202, "")
      _error -> send_resp(conn, 500, "")
    end
  end
end
