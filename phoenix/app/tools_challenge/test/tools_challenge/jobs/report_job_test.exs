defmodule ToolsChallenge.ReportJobTest do
  use ToolsChallenge.DataCase

  import Mock

  alias ToolsChallenge.Products
  alias ToolsChallenge.Products.Product
  alias ToolsChallenge.Services.{CsvExport, Elasticsearch}
  alias ToolsChallenge.Jobs.ReportJob
  alias ToolsChallenge.Clients.MailerClient

  @valid_attrs %{
    sku: "ABC-123",
    description: "some description",
    name: "some name",
    price: 120.5,
    quantity: 42,
    barcode: "123456789"
  }

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Products.create_product()
    product
  end

  setup_with_mocks([
    {File, [], write: fn _path, _data -> :ok end}
  ]) do
    :ok
  end

  describe "perform" do
    setup [:clear_elasticsearch]

    test "successful when report generated" do
      with_mock(MailerClient, [], send_report: fn -> {:ok, %HTTPoison.Response{}} end) do
        ReportJob.perform()

        assert_called(MailerClient.send_report())
      end
    end

    test "convert products to csv format" do
      product = product_fixture()

      expected_result = [
        "barcode,description,id,name,price,quantity,sku\r\n",
        "123456789,some description,636e633f8284b151ebfbb836,some name,120.5,42,ABC-123\r\n"
      ]

      product_attrs = Product.get_attrs(product)

      with_mocks([
        {Elasticsearch, [], list: fn _path -> {:ok, [%{product_attrs | id: "636e633f8284b151ebfbb836"}]} end},
        {MailerClient, [], send_report: fn -> {:ok, %HTTPoison.Response{}} end}
      ]) do
        ReportJob.perform()
        {:ok, content} = File.read(CsvExport.get_path())

        assert_called(MailerClient.send_report())

        assert expected_result == content
      end
    end
  end

  defp clear_elasticsearch(_) do
    Elasticsearch.clear()
    :ok
  end
end
