# frozen_string_literal: true
class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements, source: 'product'

  validates :total, numericality: { greater_than_or_equal_to: 0 }, presence: true

  before_validation :set_total!

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      product_id = product_id_and_quantity["product_id"].to_i
      quantity = product_id_and_quantity["quantity"].to_i
      placement = placements.build(product_id: product_id, quantity: quantity)
      yield placement if block_given?
    end
  end

  private

  def set_total!
    self.total = self.products.map(&:price).sum
  end
end
