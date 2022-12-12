defmodule ToolsChallenge.Jobs.ReportJob do
  alias ToolsChallenge.Services.CsvExport

  def perform() do
    CsvExport.write_csv()
  end
end
