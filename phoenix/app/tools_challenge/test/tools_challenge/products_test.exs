defmodule ToolsChallenge.ProductsTest do
  use ToolsChallenge.DataCase

  import Mock

  alias ToolsChallenge.Products
  alias ToolsChallenge.Products.Product
  alias ToolsChallenge.Services.Elasticsearch

  @valid_attrs %{
    sku: "ABC-123",
    description: "some description",
    name: "some name",
    price: 120.5,
    quantity: 42,
    barcode: "123456789"
  }

  @update_attrs %{
    sku: "321-BCA",
    description: "some updated description",
    name: "some updated name",
    price: 456.7,
    quantity: 43,
    barcode: "987654321"
  }

  @invalid_attrs %{
    sku: nil,
    description: nil,
    name: nil,
    price: nil,
    quantity: nil,
    barcode: nil
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

      product_attrs = Product.get_attrs(product)

      with_mock Elasticsearch,
        list: fn
          _path -> {:ok, [product_attrs]}
        end do
        assert Products.list_products("") == [product_attrs]
      end
    end
  end

  describe "get_products" do
    test "returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end
  end

  describe "create_product" do
    test "with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.sku == "ABC-123"
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.quantity == 42
      assert product.barcode == "123456789"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end
  end

  describe "update_product" do
    test "with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.sku == "321-BCA"
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.quantity == 43
      assert product.barcode == "987654321"
    end

    test "with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end
  end

  describe "delete_product" do
    test "deletes the product with correct id" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end
  end

  describe "change_product" do
    test "returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  defp clear_elasticsearch(_) do
    Elasticsearch.clear()
    :ok
  end
end
