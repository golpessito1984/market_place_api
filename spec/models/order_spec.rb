require 'rails_helper'

RSpec.describe Order, type: :model do

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context 'with valid total and user' do
    it 'create successfully' do
      order = Order.new(total: 1500,
                        user_id: @user.id)
      expect(order).to be_valid
    end
  end

  context 'with negative total' do
    it 'cannot create successfully' do
      order = Order.new(total: -1,
                        user_id: @user.id)
      expect(order).to be_invalid
    end
  end

  context 'without user' do
    it 'cannot create successfully' do
      order = Order.new(total: 1500,
                        user_id: nil)
      expect(order).to be_invalid
    end
  end

  context 'with valid order' do
    before(:each) do
      @seller = FactoryBot.create(:user)
      @buyer = FactoryBot.create(:user)
      @order = FactoryBot.create(:order, user_id: @buyer.id)
      @product1 = FactoryBot.create(:product, user_id: @user.id)
      @product2 = FactoryBot.create(:product, user_id: @user.id)
      placement = FactoryBot.create(:placement, product_id: @product1.id,
                                                order_id: @order.id)
      placement2 = FactoryBot.create(:placement, product_id: @product2.id,
                                                 order_id: @order.id)
    end

    it "we can list order's products" do
      expect(@order.products.count).to eq(2)
      expect(@order.products).to match_array([@product1, @product2])
    end
  end

end