class Product < ApplicationRecord
  belongs_to :user

  validates :price, numericality: { greater_than_or_equal_to: 0
  }, presence: true

  scope :filter_by_title, lambda { |title|
    where('lower(title) LIKE ?', "%#{title.downcase}%")
  }

  scope :above_or_equal_to_price, lambda { |price|
    where('price >= ?', price)
  }

  scope :below_or_equal_to_price, lambda { |price|
    where('price <= ?', price)
  }

  scope :recent, -> { order(updated_at: :desc)}

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    products = products.filter_by_title(params[:keyboard]) if params[:keyboard]
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
    products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]
    products
  end

end
