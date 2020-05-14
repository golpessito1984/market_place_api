class User < ApplicationRecord
  # bcrypt gem
  has_secure_password

  validates_format_of :email, with: /@/
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password_digest, presence: true
end
