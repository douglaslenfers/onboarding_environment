defmodule ToolsChallenge.Services.ReportService do
  alias ToolsChallenge.Services.CsvExport

  def request_report() do
    CsvExport.write_csv()
  end

  def get_path() do
    CsvExport.get_path()
  end
end
