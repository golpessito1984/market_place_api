# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end
  context 'with valid price, published, title, user_id' do
    it 'create successfully' do
      product = Product.new(price: 25, title: 'Soccer Ball', published: false,
                            user_id: @user.id)
      expect(product).to be_valid
    end
  end
  context 'with negative price' do
    it 'cannot create successfully' do
      product = Product.new(price: -1, title: 'Basketball ball', published: false,
                            user_id: @user.id)

      expect(product).to be_invalid
    end
  end
  context 'search engine' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)

      @product = FactoryBot.create(:product, title: 'TV Plosmo Philopps',
                                             price: 9999.99,
                                             published: false,
                                             user_id: @user.id)

      @product2 = FactoryBot.create(:product, title: 'Azos Zeenbok',
                                              price: 499.99,
                                              published: false,
                                              user_id: @user2.id)

      @product3 = FactoryBot.create(:product, title: 'Cheap TV',
                                              price: 99.99,
                                              published: false,
                                              user_id: @user2.id)
    end

    it 'can filter by name' do
      expect(Product.filter_by_title('TV').count).to eq(2)
    end

    it 'can filter ( above_or_equal_to_price )' do
      expect(Product.above_or_equal_to_price(200).sort).to match_array([@product, @product2])
    end

    it 'should order by creation_date' do
      @product2.update(updated_at: Time.now + 5)
      @product3.update(updated_at: Time.now + 3)
      expect(Product.recent.to_a).to eq([@product2, @product3, @product])
    end

    it 'can filter by title and by price ( above or equal to price )' do
      search_hash = { keyboard: 'videogame', min_price: 100 }
      expect(Product.search(search_hash).count).to eq(0)
    end

    it 'can filter by products id' do
      search_hash = {product_ids: [@product.id]}
      expect(Product.search(search_hash).count).to eq(1)
    end

    it 'can filter by title and price between min_price and max_price' do
      search_hash = { keyboard: 'tv', min_price: 100, max_price: 10_000 }
      expect(Product.search(search_hash).count).to eq(1)
    end

    it 'can get all Product without search hash' do
      search_hash = { }
      expect(Product.search(search_hash).count).to eq(3)
    end
  end
end