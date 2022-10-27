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
    product
    |> cast(attrs, [:sku, :name, :description, :quantity, :price])
    |> validate_required([:sku, :name, :description, :quantity, :price])
  end
end
