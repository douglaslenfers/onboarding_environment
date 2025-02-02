json.array!(@products) do |product|
  json.extract! product, :id, :SKU, :name, :description, :quantity, :price
  json.url product_url(product, format: :json)
end
