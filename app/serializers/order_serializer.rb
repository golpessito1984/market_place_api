class OrderSerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: true, cache_length: 12.hours

  has_many :products
  belongs_to :user
end
