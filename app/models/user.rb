class User < ApplicationRecord
  # bcrypt gem
  has_secure_password
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates_format_of :email, with: /@/
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password_digest, presence: true
end
