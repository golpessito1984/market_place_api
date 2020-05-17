class Placement < ApplicationRecord
  belongs_to :product, inverse_of: :placements
  belongs_to :order, inverse_of: :placements

  after_create :decrement_product!

  private

  def decrement_product!
    product.decrement!(:quantity, quantity)
  end

end
