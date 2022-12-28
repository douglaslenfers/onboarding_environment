defmodule ToolsChallenge.Jobs.ReportJob do
  alias ToolsChallenge.Services.CsvExport
  alias ToolsChallenge.Clients.MailerClient

  def perform() do
    with :ok <- CsvExport.write_csv() do
      MailerClient.send_report()
    end
  end
end
