FactoryBot.define do
  factory :order do
    total { Faker::Number.decimal(l_digits: 2) }
    user { nil }
  end
end
