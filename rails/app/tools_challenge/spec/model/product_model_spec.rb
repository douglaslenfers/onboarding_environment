require 'rails_helper'

RSpec.describe Product, :type => :model do
    context "Validate product SKU" do
        it "be valid" do
            product = Product.new(SKU: "ABCD123EF", name: "Primeiro Produto", description: "Descrição Produto", quantity: 5, price: 10.5)
            expect(product).to be_valid
        end

        it "not valid" do
            product = Product.new(name: "Nome Produto", description: "Descrição Produto", quantity: 5, price: 10.5)
            expect(product).to_not be_valid
        end

        it "return can't be blank" do
            product = Product.new(SKU: nil, name: "Primeiro Produto", description: "Descrição Produto", quantity: 5, price: 10.5)
            product.valid?
            expect(product.errors[:SKU]).to include("can't be blank")
        end
    end

    context "Validate product name" do
        it "be valid" do
            product = Product.new(SKU: "ABCD123EF", name: "Segundo Produto", description: "Descrição Produto", quantity: 5, price: 10.5)
            expect(product).to be_valid
        end

        it "not valid" do
            product = Product.new(SKU: "ABCD123EF", description: "Descrição Produto", quantity: 5, price: 10.5)
            expect(product).to_not be_valid
        end

        it "return can't be blank" do
            product = Product.new(SKU: "ABCD123EF", name: nil, description: "Descrição Produto", quantity: 5, price: 10.5)
            product.valid?
            expect(product.errors[:name]).to include("can't be blank")
        end
    end
end
