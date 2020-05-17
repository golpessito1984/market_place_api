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

end