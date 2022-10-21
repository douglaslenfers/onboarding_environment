FactoryBot.define do
  
    factory :product do
        SKU { "ABCD123EF" }
        name { "Primeiro Produto" }
        description { "Descrição Produto" }
        quantity { 5 }
        price { 10.5 }
    end
end
