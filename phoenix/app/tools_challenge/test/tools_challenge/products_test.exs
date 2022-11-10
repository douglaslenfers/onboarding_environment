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

    test "with blank data returns error changeset" do
      expected_errors = [
        sku: {"can't be blank", []},
        name: {"can't be blank", []},
        price: {"can't be blank", []},
        barcode: {"can't be blank", []}
      ]

      assert {:error, response} = Products.create_product(@invalid_attrs)
      assert response.errors == expected_errors
    end

    test "with price not greater than zero returns error changeset" do
      product = %{@valid_attrs | price: 0}

      expected_errors = [
        price: {"must be greater than %{number}", [number: 0]}
      ]

      assert {:error, response} = Products.create_product(product)
      assert response.errors == expected_errors
    end

    test "with barcode less than 8 characters returns error changeset" do
      product = %{@valid_attrs | barcode: "1234567"}

      expected_errors = [
        barcode: {"should be at least %{count} character(s)", [count: 8]}
      ]

      assert {:error, response} = Products.create_product(product)
      assert response.errors == expected_errors
    end

    test "with barcode more than 13 characters returns error changeset" do
      product = %{@valid_attrs | barcode: "123456789101112"}

      expected_errors = [
        barcode: {"should be at most %{count} character(s)", [count: 13]}
      ]

      assert {:error, response} = Products.create_product(product)
      assert response.errors == expected_errors
    end

    test "with sku invalid returns error changeset" do
      product = %{@valid_attrs | sku: "ABC 123"}

      expected_errors = [
        sku: {"should be only alphanumerics and hifen", []}
      ]

      assert {:error, response} = Products.create_product(product)
      assert response.errors == expected_errors
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

    test "with blank data returns error changeset" do
      product = product_fixture()

      expected_errors = [
        sku: {"can't be blank", []},
        name: {"can't be blank", []},
        price: {"can't be blank", []},
        barcode: {"can't be blank", []}
      ]

      assert {:error, response} = Products.update_product(product, @invalid_attrs)
      assert response.errors == expected_errors
      assert product == Products.get_product!(product.id)
    end

    test "with price not greater than zero returns error changeset" do
      product = product_fixture()

      expected_errors = [
        price: {"must be greater than %{number}", [number: 0]}
      ]

      new_attrs = %{@valid_attrs | price: 0}
      assert {:error, response} = Products.update_product(product, new_attrs)
      assert response.errors == expected_errors
    end

    test "with barcode less than 8 characters returns error changeset" do
      product = product_fixture()

      expected_errors = [
        barcode: {"should be at least %{count} character(s)", [count: 8]}
      ]

      new_attrs = %{@valid_attrs | barcode: "1234567"}
      assert {:error, response} = Products.update_product(product, new_attrs)
      assert response.errors == expected_errors
    end

    test "with barcode more than 13 characters returns error changeset" do
      product = product_fixture()

      expected_errors = [
        barcode: {"should be at most %{count} character(s)", [count: 13]}
      ]

      new_attrs = %{@valid_attrs | barcode: "123456789101112"}
      assert {:error, response} = Products.update_product(product, new_attrs)
      assert response.errors == expected_errors
    end

    test "with sku invalid returns error changeset" do
      product = product_fixture()

      expected_errors = [
        sku: {"should be only alphanumerics and hifen", []}
      ]

      new_attrs = %{@valid_attrs | sku: "ABC 123"}
      assert {:error, response} = Products.update_product(product, new_attrs)
      assert response.errors == expected_errors
    end
  end

  describe "delete_product" do
    test "when the product is correct" do
      product = product_fixture()

      with_mock Elasticsearch,
        delete: fn
          _path, _key, _value -> :ok
        end do
        assert {:ok, %Product{}} = Products.delete_product(product)
        assert_called(Elasticsearch.delete(:_, :_, :_))
      end
    end

    test "without product returns error" do
      product = product_fixture()

      with_mock Elasticsearch,
        delete: fn
          _path, _key, _value -> :error
        end do
        Products.delete_product(product)
        catch_error(Products.delete_product(product))
      end
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
