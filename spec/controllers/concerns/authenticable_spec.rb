require 'rails_helper'

class MockController
  include Authenticable
  attr_accessor :request
  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe Authenticable do
  context 'with valid token' do
    before(:each) do
      @user = FactoryBot.create(:user, password:'222333')
      @authentication = MockController.new
    end

    it 'can set current user successfully' do
      @authentication.request.headers['Authorization'] = JwtWebToken.encode(user_id: @user.id)
      expect(@authentication.current_user).to eq(@user)
    end

    it 'cant not set current user if header is nil' do
      @authentication.request.headers['Authorization'] = nil
      expect(@authentication.current_user).to eq(nil)
    end

  end
end