defmodule ToolsChallenge.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :sku, :string
    field :description, :string
    field :name, :string
    field :price, :float
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    id = product.id

    product
    |> cast(attrs, [:sku, :name, :description, :quantity, :price])
    |> validate_required([:sku, :name])
    |> validate_length(:description, max: 255)
  end

  def get_attrs(product) do
    %{
      id: product.id,
      sku: product.sku,
      name: product.name,
      description: product.description,
      quantity: product.quantity,
      price: product.price
    }
  end
end
