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
end