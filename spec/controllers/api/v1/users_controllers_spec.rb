# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  describe 'User GET #show' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product, user_id: @user.id)
      @product2 = FactoryBot.create(:product, user_id: @user.id)
    end

    it 'return a successfully response with valid user id' do
      get :show, params: {id: @user.id}
      expect(response.status).to eq(200)
      attributes = JSON.parse(response.body, symbolize_names:
          true)[:data][:attributes]
      included = JSON.parse(response.body,symbolize_names:
          true)[:included]
      expect(attributes[:email]).to eq(@user.email)
      expect(included.count).to eq(2)
    end

    it 'return a error message when resource not found' do
      get :show, params: {id: -1}
      expect(response.status).to eq(404)
      hash_body = JSON.parse(response.body)
      expect(hash_body['errors']).to eq('Record not found')
    end
  end

  describe 'User POST #create' do
    before(:each) do
      @user_params = {user: {email: 'david.ruizdelarosa@gmail.com',
                             password: '222333' }}
    end

    it 'return a successfully new user' do
      expect do
        post :create, params: @user_params
      end.to change(User, :count).by(1)

      expect(response.status).to eq(201)
      attributes = JSON.parse(response.body)['data']['attributes']
      expect(attributes['email']).to eq(@user_params[:user][:email])
    end

    it 'return a error message when params ara invalid' do
      user_invalid_params = {user: {email: 'david.ruizdelarosa',
                                    password: '222333'}}

      expect do
        post :create, params: user_invalid_params
      end.to change(User, :count).by(0)

      expect(response.status).to eq(422)
      hash_body = JSON.parse(response.body)
      expect(hash_body['email']).to match_array(['is invalid'])
    end
  end

  describe 'User DELETE #destroy' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @bearer_token = { Authorization:
                            JwtWebToken.encode(user_id: @user.id) }
    end

    context 'with bearer token' do
      it 'successfully destroy with valid user id' do
        request.headers.merge!(@bearer_token)
        expect do
          delete :destroy, params: {id: @user.id}
        end.to change(User, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context 'with bearer token' do
      it 'successfully destroy with valid user id' do
        expect do
          delete :destroy, params: {id: @user.id}
        end.to change(User, :count).by(0)
        expect(response.status).to eq(403)
        hash_body = JSON.parse(response.body)
        expect(hash_body['errors']).to eq('Forbidden action')
      end
    end

  end

  describe 'User PUT #update' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @user_params = { email: 'raul.ruizdelarosa@gmail.com',
                       password: '111222' }
      @bearer_token = { Authorization:
          JwtWebToken.encode(user_id: @user.id) }
    end

    context 'with not bearer token' do
      it 'not successfully update to unauthorized user' do
        put :update, params: {id: @user.id, user: @user_params}
        expect(response.status).to eq(403)
        hash_body = JSON.parse(response.body)
        expect(hash_body['errors']).to eq('Forbidden action')
      end
    end

    context 'with correct bearer token' do
      it 'successfully update' do
        request.headers.merge!(@bearer_token)
        put :update, params: {id: @user.id, user: @user_params}
        expect(response.status).to eq(200)
        attributes = JSON.parse(response.body)['data']['attributes']
        expect(attributes['email']).to eq( @user_params[:email])
      end

      it 'not successfully with invalid email' do
        request.headers.merge!(@bearer_token)
        @user_params[:email] = 'david.ruizdelarosa.gmail.com'
        put :update, params: {id: @user.id, user: @user_params}
        expect(response.status).to eq(422)
        hash_body = JSON.parse(response.body)
        expect(hash_body['email']).to match_array(['is invalid'])
      end

    end
  end
end