require 'rails_helper'

RSpec.describe Product, :type => :model do
    subject {
        described_class.new(SKU: "ABC123DEF",
                            name: "Nome do produto",
                            description: "Descrição do produto",
                            quantity: 5,
                            price: 10.5)
    }

    context "Validate product SKU" do
        it "be valid" do
            expect(subject).to be_valid
        end

        it "not valid" do
            subject.SKU = nil
            expect(subject).to_not be_valid
        end

        it "return can't be blank" do
            subject.SKU = nil
            subject.valid?
            expect(subject.errors[:SKU]).to include("can't be blank")
        end
    end

    context "Validate product name" do
        it "be valid" do
            expect(subject).to be_valid
        end

        it "not valid" do
            subject.name = nil
            expect(subject).to_not be_valid
        end

        it "return can't be blank" do
            subject.name = nil
            subject.valid?
            expect(subject.errors[:name]).to include("can't be blank")
        end
    end

    context "Validate product description" do
        it "be valid" do
            expect(subject).to be_valid
        end

        it "can be blank" do
            subject.description = nil
            expect(subject).to be_valid
        end

        it "return is too long" do
            subject.description = "a" * 256
            subject.valid?
            expect(subject.errors[:description]).to include("is too long (maximum is 255 characters)")
        end
    end

    context "Validate product quantity" do
        it "be valid" do
            expect(subject).to be_valid
        end

        it "not valid" do
           subject.quantity = -10
           expect(subject).to_not be_valid
        end

        it "return is not a number" do
            subject.quantity = "Test"
            subject.valid?
            expect(subject.errors[:quantity]).to include("is not a number")
        end

        it "return can't be blank" do
            subject.quantity = nil
            subject.valid?
            expect(subject.errors[:quantity]).to include("can't be blank")
        end
    end

    context "Validate product price" do
        it "be valid" do
            expect(subject).to be_valid
        end

        it "not valid" do
            subject.price = -10
            expect(subject).to_not be_valid
        end

        it "return is not a number" do
            subject.price = "Test"
            subject.valid?
            expect(subject.errors[:price]).to include("is not a number")
        end

        it "return can't be blank" do
            subject.price = nil
            subject.valid?
            expect(subject.errors[:price]).to include("can't be blank")
        end
    end
end
