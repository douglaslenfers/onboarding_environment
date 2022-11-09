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
    field :barcode, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    id = product.id

    product
    |> cast(attrs, [:sku, :name, :description, :quantity, :price, :barcode])
    |> validate_required([:sku, :name, :price, :barcode])
    |> validate_length(:description, max: 255)
    |> validate_length(:barcode, min: 8, max: 13)
    |> validate_number(:price, greater_than: 0)
  end

  def get_attrs(product) do
    %{
      id: product.id,
      sku: product.sku,
      name: product.name,
      description: product.description,
      quantity: product.quantity,
      price: product.price,
      barcode: product.barcode
    }
  end
end
