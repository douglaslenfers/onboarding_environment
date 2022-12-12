defmodule ToolsChallengeWeb.ReportControllerTest do
  use ToolsChallenge.DataCase
  use ToolsChallengeWeb.ConnCase

  import Mock

  alias ToolsChallenge.Products
  alias ToolsChallenge.Jobs.ReportJob

  setup_all do
    expected_report = get_fixture(:expected_report)

    [expected_report: expected_report]
  end

  setup do
    Products.create_product(%{
      "id" => "636e633f8284b151ebfbb836",
      "sku" => "ABC-123",
      "name" => "some name",
      "description" => "some description",
      "quantity" => 42,
      "price" => 120.5,
      "barcode" => "123456789"
    })

    ReportJob.perform()

    :ok
  end

  describe "equeue_report" do
    test "success", %{conn: conn} do
      with_mock(ReportJob, [], enqueue: :ok) do
        post(conn, Routes.report_path(conn, :equeue_report))

        assert_called(ReportJob.enqueue())
      end
    end
  end

  describe "get_report" do
    test "return the CSV file for download", %{conn: conn, expected_report: expected_report} do
      conn = get(conn, Routes.report_path(conn, :get_report))

      assert conn.resp_body == expected_report
    end
  end

  defp get_fixture(fixture) do
    {:ok, content} =
      fixture
      |> get_fixture_path()
      |> File.read()

    content
  end

  defp get_fixture_path(:expected_report),
    do: "/app/tools_challenge/test/tools_challenge/fixtures/products_report_test.csv"
end
