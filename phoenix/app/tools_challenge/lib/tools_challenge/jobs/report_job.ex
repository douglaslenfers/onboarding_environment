defmodule ToolsChallenge.Jobs.ReportJob do
  alias ToolsChallenge.Services.ReportService

  def perform() do
    ReportService.request_report()
  end
end
