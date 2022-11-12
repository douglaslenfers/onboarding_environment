defmodule ToolsChallenge.Services.CsvExportTest do
  use ToolsChallenge.DataCase

  import Mock

  alias ToolsChallenge.Products
  alias ToolsChallenge.Products.Product
  alias ToolsChallenge.Services.CsvExport
  alias ToolsChallenge.Services.Elasticsearch

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

  describe "list products" do
    setup [:clear_elasticsearch]

    test "returns all products" do
      product = product_fixture()

      expected_result = [
        "barcode,description,id,name,price,quantity,sku\r\n",
        "123456789,some description,636e633f8284b151ebfbb836,some name,120.5,42,ABC-123\r\n"
      ]

      product_attrs = Product.get_attrs(product)

      with_mock Elasticsearch,
        list: fn
          _path -> {:ok, [%{product_attrs | id: "636e633f8284b151ebfbb836"}]}
        end do
        assert CsvExport.generate_csv() == expected_result
      end
    end
  end

  defp clear_elasticsearch(_) do
    Elasticsearch.clear()
    :ok
  end
end
