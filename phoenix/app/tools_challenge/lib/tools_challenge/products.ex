defmodule ToolsChallenge.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false

  alias ToolsChallenge.Repo
  alias ToolsChallenge.Products.Product
  alias ToolsChallenge.Services.{Redis, Elasticsearch}

  @doc """
  Returns the list of products.
  """
  def list_products(search_text) do
    case search_elasticsearch(search_text) do
      {:ok, products_list} ->
        products_list

      :ok ->
        []

      _ ->
        if search_text != nil do
          regex = Mongo.Ecto.Helpers.regex(search_text, "i")
          query = from p in Product,
                    where: fragment(sku: ^regex)

          Repo.all(query)
        else
          Repo.all(Product)
        end
    end
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.
  """
  def get_product!(id) do
    case Redis.get(id) do
      {:ok, product} ->
        product

      {:error, :not_found} ->
        product = Repo.get!(Product, id)
        Redis.set(id, product)
        product

      _ ->
        Repo.get!(Product, id)
    end
  end

  @doc """
  Creates a product.
  """
  def create_product(attrs \\ %{}) do
    product_changeset = Product.changeset(%Product{}, attrs)
    product = Repo.insert(product_changeset)
    with {:ok, :created} <- post_elasticsearch(product) do
      {:ok, product}
    end
  end

  @doc """
  Updates a product.
  """
  def update_product(%Product{} = product, attrs) do
    Product.changeset(product, attrs)
    |> Repo.update()
    |> Product.get_attrs()
    |> update_elasticsearch()
  end

  @doc """
  Deletes a product.
  """
  def delete_product(%Product{} = product) do
    delete_elasticsearch(product)
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.
  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  defp search_elasticsearch([{_key, _value} | _] = filters) do
    Elasticsearch.search("products", filters)
  end

  defp search_elasticsearch(_) do
    Elasticsearch.list("products")
  end

  defp post_elasticsearch(product) do
    Elasticsearch.post("products", Product.get_attrs(product))
  end

  defp update_elasticsearch(updated_product) do
    Elasticsearch.update("products", "id", updated_product.id, updated_product)
  end

  defp delete_elasticsearch(%Product{} = product) do
    Elasticsearch.delete("products", "id", product.id)
  end
end
