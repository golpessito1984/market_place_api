require 'rails_helper'

RSpec.describe Placement, type: :model do
  before(:each) do
    @seller = FactoryBot.create(:user)
    @product = FactoryBot.create(:product,
                                 user_id: @seller.id)
    @buyer = FactoryBot.create(:user)
    @order = FactoryBot.create(:order,
                               user_id: @buyer.id)



  end
  context('with a correct product and correct order') do
    it 'successfully create' do
      placement = Placement.new(product_id: @product.id,
                                order_id: @order.id)
      expect(placement).to be_valid
    end
  end
end