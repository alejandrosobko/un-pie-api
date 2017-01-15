require 'rails_helper'

RSpec.describe Product, type: :model do
  
  describe 'new product' do
    it 'should not save a product without provider' do
      product = Product.new

      expect(product.save).to eq false
    end

    it 'should can save a product with provider' do
      provider = FactoryGirl.create(:provider)
      product = Product.new
      product.provider = provider

      expect(product.save).to eq true
    end

    it 'should save one product with 3 of amount' do
      product = FactoryGirl.build(:product_with_provider)
      product.amount = 3

      expect(product.save).to eq true
      expect(Product.find(1).amount).to eq 3
    end

    it 'returns false when ask for own' do
      product = FactoryGirl.create(:product_with_provider)

      expect(product.own).to eq false
    end

    it 'should raise exception' do
      product = Product.new

      expect{product.save!}.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

end
