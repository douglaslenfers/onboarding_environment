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
end
