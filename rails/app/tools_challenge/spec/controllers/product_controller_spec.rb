require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do
    context "GET #index" do
        let(:subject) { create(:product) }

        it "should success and render index page" do
            get :index
            expect(response).to have_http_status(200)
            expect(response).to render_template(:index)
        end

        it "should have one product" do
            get :index
            expect(:products).to_not be_empty
        end
    end

    context "GET #show" do
        let(:subject) { create(:product) }

        it "should success and render show page" do
            get :show, :id => subject.id
            expect(response).to have_http_status(200)
            expect(response).to render_template(:show)
        end
    end

    context "GET #new" do
        it "should success and render new page" do
            get :new
            expect(response).to have_http_status(200)
            expect(response).to render_template(:new)
        end
    end

    context "GET #edit" do
        let(:subject) { create(:product) }

        it "should success and render edit page" do
            get :edit, :id => subject.id
            expect(response).to have_http_status(200)
            expect(response).to render_template(:edit)
        end
        it "should not render edit page without id" do
            get :edit, :id => ""
            expect(response).to_not render_template(:edit)
        end
    end

    context "POST #create" do
        it "should success create and redirect to product page" do
            post :create, product: { SKU: "ABCD123EF", name: "Primeiro Produto", description: "Descrição Produto", quantity: 5, price: 10.5 }
            expect(response).to have_http_status(302)
        end
    end

    context "PATCH #update" do
        let(:subject) { create(:product) }

        it "should success update and render update page" do
            patch :update, id: subject.id, product: { SKU: "BBB222CCC" }
            expect(response).to have_http_status(200)
            expect(response).to render_template(:index)
        end
    end

    describe 'DELETE #destroy' do
        let(:subject) { create(:product) }

        it 'should remove the requested product' do
            expect do
                delete :destroy, :id => subject.id
            end.to change(Product, :count).by(-1)
            expect(response).to_not redirect_to(:index)
        end

        it 'should not remove product without id' do
            delete :destroy, :id => " "
            expect(response).to_not redirect_to(:index)
        end
    end
end
