defmodule ToolsChallenge.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  import Exredis

  alias ToolsChallenge.Repo
  alias ToolsChallenge.Products.Product

  @doc """
  Returns the list of products.
  """
  def list_products(search_text) do
    if search_text != nil do
      regex = Mongo.Ecto.Helpers.regex(search_text, "i")
      query = from p in Product,
                where: fragment(sku: ^regex)

      Repo.all(query)
    else
      Repo.all(Product)
    end
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.
  """
  def get_product!(id) do
    case get_product(id) do
      {:ok, product} ->
        product

      {:error, :not_found} ->
        product = Repo.get!(Product, id)
        set_product(id, product)
        product

      _ ->
        Repo.get!(Product, id)
    end
  end

  @doc """
  Creates a product.
  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.
  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.
  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.
  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  defp set_product(id, product) do
    {:ok, client} = Exredis.start_link
    client |> Exredis.query ["SET", id, product]
    client |> Exredis.stop
  end

  defp get_product(id) do
    {:ok, client} = Exredis.start_link
    client |> Exredis.query ["GET", id]
    client |> Exredis.stop
  end
end
