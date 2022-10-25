class Product
  include Mongoid::Document
  field :SKU, type: String
  field :name, type: String
  field :description, type: String
  field :quantity, type: Integer, default: 0
  field :price, type: Float, default: 0.0

  validates :description, length: { maximum: 255 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :SKU, :name
end
