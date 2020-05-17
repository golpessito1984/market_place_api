FactoryBot.define do
  factory :product do
    price { Faker::Number.decimal(l_digits: 2) }
    title { Faker::Beer.name }
    published { false }
    user_id { nil }
    quantity { 5 }
  end
end
