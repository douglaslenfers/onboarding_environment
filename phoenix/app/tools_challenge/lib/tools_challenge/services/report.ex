defmodule ToolsChallenge.Services.Report do
  alias ToolsChallenge.Services.Redis
  alias ToolsChallenge.Jobs.Report

  def request_report(report_name) do
    with {:ok, :completed} <- get_report_status(report_name),
         {:ok, report_data} <- get_saved_report(report_name) do
      {:ok, report_data}
    else
      {:ok, :generating} ->
        {:not_yet, "Not yet completed"}

      {:error, :not_found} ->
        enqueue_report(report_name)

      error ->
        {:error, error}
    end
  end

  defp get_report_status(report_name) do
    Redis.get("#{report_name}_status")
  end

  defp get_saved_report(report_name) do
    case File.read("#{report_name}.csv") do
      {:ok, data} -> {:ok, data}

      _ -> {:error, :not_found}
    end
  end

  defp enqueue_report(report_name) do
    case Report.enqueue(report_name) do
      {:ok, _id} -> {:queued, "Report will be generated soon"}
      _error -> {:error, "Error to generate the report"}
    end
  end
end
