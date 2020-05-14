class User < ApplicationRecord
  validates_format_of :email, with: /@/
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password_digest, presence: true
end
