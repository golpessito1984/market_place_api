require 'rails_helper'

RSpec.describe Api::V1::OrdersController do
  before(:each) do
    @seller = FactoryBot.create(:user)
    @buyer = FactoryBot.create(:user)
    @order = FactoryBot.create(:order, user_id: @buyer.id)
    @product1 = FactoryBot.create(:product, user_id: @seller.id)
    @product2 = FactoryBot.create(:product, user_id: @seller.id)
    @placement = FactoryBot.create(:placement, product_id: @product1.id,
                                               order_id: @order.id)
    @placement2 = FactoryBot.create(:placement, product_id: @product2.id,
                                                order_id: @order.id)
  end
  describe 'Order GET #index' do
    it 'successfully when user is logged' do
      bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @buyer.id) }

      request.headers.merge!(bearer_token)
      get :index
      expect(response.status).to eq(200)
    end

    it 'not successfully when user is not logged' do
      get :index
      expect(response.status).to eq(401)
    end
  end
end
