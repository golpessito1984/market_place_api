require 'rails_helper'

RSpec.describe Api::V1::ProductsController do

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe 'Product GET #index' do
    before(:each) do
      @product1 = FactoryBot.create(:product, user_id: @user.id)
      @product2 = FactoryBot.create(:product, user_id: @user.id)
      @product3 = FactoryBot.create(:product, user_id: @user.id)
    end

    it 'successfully return all products' do
      get :index
      expect(response.status).to eq(200)
      hash_body = JSON.parse(response.body)
      expect(hash_body.count).to eq(3)
    end
  end

  describe 'Product GET #show' do
    before(:each) do
      @product = FactoryBot.create(:product,
                                   user_id: @user.id)
    end

    it 'successfully with valid product id' do
      get :show, params: {id: @product.id}
      expect(response.status).to eq(200)
      hash_body = JSON.parse(response.body)
      expect(hash_body["title"]).to eq(@product.title)
      expect(hash_body["price"]).to eq("#{@product.price.round(2)}")
      expect(hash_body["published"]).to eq(@product.published)
    end
  end

  describe 'Product POST #create' do
    before(:each) do
      @product_params = {product: { title: 'Soccer Ball',
                                    price: 10.5,
                                    published: false}}

      @bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @user.id) }
    end

    it 'can successfully with one user logged' do
      request.headers.merge!(@bearer_token)
      expect do
        post :create, params: @product_params
      end.to change(Product, :count).by(1)

      expect(response.status).to eq(201)
      hash_body = JSON.parse(response.body)
      expect(hash_body["title"]).to eq('Soccer Ball')
    end

    it 'cannot successfully without login' do
      post :create, params: @product_params
      expect(response.status).to eq(401)
      hash_body = JSON.parse(response.body)
      expect(hash_body["errors"]).to eq('Unauthorized')
    end
  end

  describe 'Product DELETE #destroy' do
    before(:each) do
      @user2 = FactoryBot.create(:user)

      @product = FactoryBot.create(:product,
                                   user_id: @user.id)
      @bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @user.id) }

      @bearer_token_user2 = { Authorization:
                                   JwtWebToken.encode(user_id: @user2.id) }
    end

    it 'cannot destroy if user is not the logged' do
      delete :destroy, params:{id: @product.id}
      expect(response.status).to eq(401)
    end

    it 'cannot destroy if user is not the owher' do
      request.headers.merge!(@bearer_token_user2)
      delete :destroy, params:{id: @product.id}
      expect(response.status).to eq(403)
    end

    it 'can destroy successfully with owner user logged' do
      request.headers.merge!(@bearer_token)
      expect do
        delete :destroy, params:{id: @product.id}
      end.to change(Product, :count).by(-1)
      expect(response.status).to eq(204)
    end

  end

  describe "Product PUT #update" do
    before(:each) do
      @user2 = FactoryBot.create(:user)
      @product = FactoryBot.create(:product,
                                   user_id: @user.id)
      @bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @user.id) }

      @bearer_token_user2 = { Authorization:
                                  JwtWebToken.encode(user_id: @user2.id) }

      @product_params = {title: 'Product updated',
                         price: '23',
                         published: false}
    end

    it 'cannot update if user is not the logged' do
      put :update, params:{id: @product.id, product: @product_params}
      expect(response.status).to eq(401)
    end

    it 'cannot update if user is not the owner' do
      request.headers.merge!(@bearer_token_user2)
      put :update, params:{id: @product.id, product: @product_params}
      expect(response.status).to eq(403)
    end

    it 'successfulyy if user is the owner' do
      request.headers.merge!(@bearer_token)
      put :update, params:{id: @product.id, product: @product_params}
      expect(response.status).to eq(200)
      hash_body = JSON.parse(response.body)
      expect(hash_body["title"]).to eq(@product_params[:title])
      expect(hash_body["published"]).to eq(@product_params[:published])
    end

  end
end