require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do
    context "GET #index" do
        it "should success and render to index page" do
            get :index
            expect(response).to have_http_status(200)
            expect(response).to render_template(:index)
        end

        it "should bring empty array" do
            get :index
            expect(assigns(:products)).to be_empty
        end

        it "should have one product" do
            product = Product.new(SKU: "ABCD123EF", name: "Primeiro Produto", description: "Descrição Produto", quantity: 5, price: 10.5)
            get :index
            expect(assigns(:products)).to_not be_empty
        end
    end

    context "GET #show" do
        let(:product) { Product.new(SKU: "ABCD123EF", name: "Primeiro Produto", description: "Descrição Produto", quantity: 5, price: 10.5) }
        it "should success and render show page" do
            get :show, params: { id: product.id }
            expect(response).to have_http_status(200)
            expect(response).to render_template(:show)
        end

        it "where have id" do
            get :show, params: { id: product.id }
            expect(assigns(:product)).to_not be_empty
        end
    end
end
