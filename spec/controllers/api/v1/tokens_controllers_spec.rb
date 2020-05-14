require 'rails_helper'

RSpec.describe Api::V1::TokensController do
  describe 'Token POST #create' do
    before(:each) do
      @user = FactoryBot.create(:user,
                                password: '222333')
      @user_params = { user: { email: @user.email,
                               password: '222333'}}
    end

    it 'successfully return authentication token' do
      post :create, params: @user_params
      expect(response.status).to eq(200)
      hash_body = JSON.parse(response.body)
      payload_token = JwtWebToken.decode(hash_body["token"])
      expect(payload_token["user_id"]).to eq(@user.id)
    end

    it 'not successfully return authentication token with not valid credentials' do
      @user_params[:user][:password] = '111222'
      post :create, params: @user_params
      expect(response.status).to eq(401)
      hash_body = JSON.parse(response.body)
      expect(hash_body["errors"]).to eq("Unauthorized")
    end
  end
end