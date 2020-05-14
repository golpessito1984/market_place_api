require 'rails_helper'

RSpec.describe User, type: :model do

  context 'with email, password_digest' do
    it 'create correctly' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com', password_digest: '222333')
      expect(user).to be_valid
    end
  end

  context 'with bad email' do
    it 'can not create correctly' do
      user = User.new(email: 'david.ruizdelarosa.com', password_digest: '222333')
      expect(user).to be_invalid
    end
  end

  context 'with duplicate email' do
    it 'can not create correctly' do
      user = FactoryBot.create(:user)
      user_two = User.new(email: "#{user.email}", password_digest: '222333')
      expect(user_two).to be_invalid
    end
  end

  context 'with valid email and without password' do
    it 'can not create correctly' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com')
      expect(user).to be_invalid
    end
  end

end