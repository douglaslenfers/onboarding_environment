defmodule ToolsChallenge.Services.ReportTest do
  use ToolsChallenge.DataCase, async: false

  import Mock

  alias ToolsChallenge.Services.Report
  alias ToolsChallenge.Services.Redis

  setup_with_mocks([
    {Redis, [],
     get: fn
       "report_completed_status" -> {:ok, :completed}
       "report_generating_status" -> {:ok, :generating}
       "report_absent_status" -> {:error, :not_found}
     end,
     set: fn _key, _data -> :ok end},
    {File, [], read: fn _path -> {:ok, "csv_data"} end}
  ]) do
    :ok
  end

  describe "request_report" do
    test_with_mock("return csv_data if exist", Exq,
      enqueue: fn _exq, _queue, _worker, _args -> {:ok, "job_id"} end
    ) do
      expected_response = {:ok, "csv_data"}

      assert Report.request_report("report_completed") == expected_response
    end

    test_with_mock("queue a job if it does not exist", Exq,
      enqueue: fn _exq, _queue, _worker, _args -> {:ok, "job_id"} end
    ) do
      expected_response = {:queued, "Report will be generated soon"}

      assert Report.request_report("report_absent") == expected_response
    end

    test_with_mock("returns not yet completed", Exq,
      enqueue: fn _exq, _queue, _worker, _args -> {:ok, "job_id"} end
    ) do
      expected_response = {:not_yet, "Not yet completed"}

      assert Report.request_report("report_generating") == expected_response
    end

    test_with_mock("return error to generate job for report", Exq,
      enqueue: fn _exq, _queue, _worker, _args -> {:error, "error_reason"} end
    ) do
      expected_response = {:error, "Error to generate the report"}

      assert Report.request_report("report_absent") == expected_response
    end
  end
end
