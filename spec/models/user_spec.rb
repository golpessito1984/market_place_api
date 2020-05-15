require 'rails_helper'

RSpec.describe User, type: :model do

  context 'with email, password_digest' do
    it 'create correctly' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com', password_digest: '222333')
      expect(user).to be_valid
    end
  end

  context 'with bcrypt installed' do
    it 'create with password correctly' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com', password: '22233')
      expect(user).to be_valid
      user.save
      user.reload
      expect(user.password_digest).not_to be_nil
    end

    it 'create with password and password_confirmation (correctly)' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com',
                      password: '222333',
                      password_confirmation: '222333')
      expect(user).to be_valid
    end

    it 'not create with password and password_confirmation (not correctly)' do
      user = User.new(email: 'david.ruizdelarosa@gmail.com',
                      password: '222333',
                      password_confirmation: '111222')

      expect(user).to be_invalid
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

  context 'with several products' do
    it 'when destroy user the related products are destroyed' do
      user = FactoryBot.create(:user)
      (1..5).each do |number|
        new_product = FactoryBot.create(:product, user_id: user.id)
      end
      expect(user.products.count).to eq(5)
      user.destroy
      expect(Product.all.count).to eq(0)
    end
  end

end