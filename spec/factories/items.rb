FactoryBot.define do
   factory :item do
     name { Faker::Commerce.unique.product_name }
     description { Faker::Food.description }
     unit_price { Faker::Number.number(digits: 5) }
   end
 end
