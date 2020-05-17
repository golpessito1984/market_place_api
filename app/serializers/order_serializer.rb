class OrderSerializer
  include FastJsonapi::ObjectSerializer
  has_many :products
  belongs_to :user
end
