defmodule ToolsChallenge.Jobs.Report do
  alias ToolsChallenge.Services.{CsvExport, Redis}

  def perform(report_name) do
    with :ok <- set_report_status(report_name, :generating),
         :ok <- CsvExport.write_csv(),
         :ok <- set_report_status(report_name, :completed) do
      :ok
    else
      _error ->
        remove_report_status(report_name)
        :error
    end
  end

  defp set_report_status(report_name, report_status) do
    Redis.set("#{report_name}_status", report_status)
  end

  defp remove_report_status(report_name) do
    Redis.del("#{report_name}_status")
  end
end
