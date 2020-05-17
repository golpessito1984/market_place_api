# frozen_string_literal: true
class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements, source: 'product'

  validates :total, numericality: { greater_than_or_equal_to: 0 }, presence: true

  before_validation :set_total!

  def set_total!
    self.total = self.products.map(&:price).sum
  end
end
