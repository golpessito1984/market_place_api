require 'rails_helper'

RSpec.describe Api::V1::OrdersController do

  before(:each) do
    @seller = FactoryBot.create(:user)
    @buyer = FactoryBot.create(:user)
    @product1 = FactoryBot.create(:product, user_id: @seller.id)
    @product2 = FactoryBot.create(:product, user_id: @seller.id)
  end

  describe 'Order GET #index' do
    before(:each) do
      @order = FactoryBot.create(:order, user_id: @buyer.id)
      @placement = FactoryBot.create(:placement, product_id: @product1.id,
                                                 order_id: @order.id)
      @placement2 = FactoryBot.create(:placement, product_id: @product2.id,
                                                  order_id: @order.id)
    end

    it 'successfully when user is logged' do
      bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @buyer.id) }

      request.headers.merge!(bearer_token)
      get :index

      expect(response.status).to eq(200)
      json_hash = JSON.parse(response.body, symbolize_names: true)
      expect(json_hash.dig(:links, :first)).not_to be_nil
      expect(json_hash.dig(:links, :last)).not_to be_nil
      expect(json_hash.dig(:links, :prev)).not_to be_nil
      expect(json_hash.dig(:links, :next)).not_to be_nil
    end

    it 'not successfully when user is not logged' do
      get :index
      expect(response.status).to eq(401)
    end
  end

  describe 'Order GET #show' do
    before(:each) do
      @order = FactoryBot.create(:order, user_id: @buyer.id)
      @placement = FactoryBot.create(:placement, product_id: @product1.id,
                                     order_id: @order.id)
      @placement2 = FactoryBot.create(:placement, product_id: @product2.id,
                                      order_id: @order.id)
    end

    it 'successfully when user is logged' do
      bearer_token = { Authorization:
                           JwtWebToken.encode(user_id: @buyer.id) }
      request.headers.merge!(bearer_token)
      get :show, params: {id: @order.id}
      expect(response.status).to eq(200)
      attributes = JSON.parse(response.body, symbolize_names:
          true)[:data]
      expect(attributes[:id].to_i).to eq(@order.id)
    end

    it 'not successfully when usr is not logged' do
      get :show, params: {id: @order.id}
      expect(response.status).to eq(401)
    end

  end

  describe 'Order POST #create' do
    before(:each) do
      @order_params = { order: { product_ids_and_quantities: [
          { product_id: @product1.id, quantity: 2 },
          { product_id: @product2.id, quantity: 3 },
      ]}}
    end

    it 'successfully with products_id, user and total' do
      bearer_token = { Authorization:
                           JwtWebToken.encode(user_id: @buyer.id) }
      request.headers.merge!(bearer_token)
      expect do
        post :create, params: @order_params
      end.to change(Order, :count).by(1)
      expect(response.status).to eq(201)
    end

    it 'not successfully with user is not logged' do
      post :create, params: @order_params
      expect(response.status).to eq(401)
    end
  end
end
