require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end
  context 'with valid price, published, title, user_id' do
    it 'create successfully' do
      product = Product.new(price: 25, title: 'Soccer Ball', published: false,
                            user_id: @user.id)
      expect(product).to be_valid
    end
  end
  context 'with negative price' do
    it 'cannot create successfully' do
      product = Product.new(price: -1, title: 'Basketball ball', published: false,
                            user_id: @user.id)

      expect(product).to be_invalid
    end
  end
end