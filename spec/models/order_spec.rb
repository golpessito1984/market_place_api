# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do

  before(:each) do
    @seller = FactoryBot.create(:user)
    @buyer = FactoryBot.create(:user)
    @product1 = FactoryBot.create(:product, user_id: @seller.id)
    @product2 = FactoryBot.create(:product, user_id: @seller.id)
    @order = Order.new(user_id: @buyer.id)
    # @order.products << @product1
    # @order.products << @product2
    @order.placements << Placement.new(product_id: @product1.id, quantity: 1)
    @order.placements << Placement.new(product_id: @product2.id, quantity: 1)
  end

  context 'with valid total and user' do
    it 'create successfully' do
      expect(@order).to be_valid
    end

    it 'create successfully and total = @product1.price + @product2.price' do
      @order.save
      expect(@order.total).to eq(@product1.price + @product2.price)
    end

  end

  context 'without user' do
    it 'cannot create successfully' do
      @order.user_id = nil
      expect(@order).to be_invalid
    end
  end

  context 'with valid order' do
    it "we can list order's products" do
      @order.save
      expect(@order.products.count).to eq(2)
      expect(@order.products).to match_array([@product1, @product2])
    end
  end

  context 'without enough stock' do
    it 'can not create successfully' do
      @order.placements << Placement.new(product_id: @product1.id, quantity: (1 + @product1.quantity))
      expect(@order).to be_invalid
    end
  end

end