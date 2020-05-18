class UserSerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: true, cache_length: 12.hours

  attributes :email
  has_many :products
end
