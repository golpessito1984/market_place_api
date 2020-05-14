require 'rails_helper'

RSpec.describe JwtWebToken, type: :model do
  context 'with same SECRET KEY' do
    it 'can encode and decode payload' do
      payload = { message: 'Hello world'}
      token = JwtWebToken.encode(payload)
      payload_returned = JwtWebToken.decode(token)
      expect(payload_returned[:message]).to eq('Hello world')
    end
  end
end