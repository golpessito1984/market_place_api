require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  describe 'User GET #show' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    it 'return a successfully response with valid user id' do
      get :show, params: {id: @user.id}
      expect(response.status).to eq(200)
      hash_body = JSON.parse(response.body)
      expect(hash_body['email']).to eq(@user.email)
      expect(hash_body['password']).to eq(@user.password)
    end

    it 'return a error message when resource not found' do
      get :show, params: {id: -1}
      expect(response.status).to eq(404)
      hash_body = JSON.parse(response.body)
      expect(hash_body["errors"]).to eq('Record not found')
    end
  end

  describe 'User POST #create' do
    before(:each) do
      @user_params = {user: {email: 'david.ruizdelarosa@gmail.com',
                             password: '222333'}}
    end

    it 'return a successfully new user' do
      expect do
        post :create, params: @user_params
      end.to change(User, :count).by(1)

      expect(response.status).to eq(201)
      hash_body = JSON.parse(response.body)
      expect(hash_body["email"]).to eq(@user_params[:user][:email])
    end

    it 'return a error message when params ara invalid' do
      user_invalid_params = {user: {email: 'david.ruizdelarosa',
                                    password: '222333'}}

      expect do
        post :create, params: user_invalid_params
      end.to change(User, :count).by(0)

      expect(response.status).to eq(422)
      hash_body = JSON.parse(response.body)
      expect(hash_body["email"]).to match_array(["is invalid"])
    end

  end
end