FactoryBot.define do
   factory :item do
     name { Faker::Commerce.unique.product_name }
     description { Faker::Food.description }
     unit_price { 15.00 }
   end
 end
