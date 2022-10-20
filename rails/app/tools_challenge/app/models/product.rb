class Product
  include Mongoid::Document
  field :SKU, type: String
  field :name, type: String
  field :description, type: String
  field :quantity, type: Integer, default: 0
  field :price, type: Float, default: 0

  validates_uniqueness_of :SKU
  validates_presence_of :SKU, :name
end
