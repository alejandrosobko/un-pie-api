require 'rails_helper'

RSpec.describe Product, type: :model do

  describe 'new product' do
    it 'should not save an empty product' do
      product = Product.new

      expect(product.save).to eq false
    end

    it 'should can save a product with brand and provider' do
      product = Product.new(brand: 'Some brand')
      product.providers = [build(:provider)]

      expect(product.save).to eq true
    end

    it 'should initialize with prices = 0.0' do
      product = Product.create!({brand: 'A brand', providers: [build(:provider)]})

      expect(product.purchase_price).to eq 0.0
      expect(product.sale_price).to eq 0.0
      expect(product.cash_price).to eq 0.0
    end

    it 'returns false when ask for own' do
      product = FactoryGirl.create(:product)

      expect(product.own).to eq false
    end

    it 'should raise exception' do
      product = Product.new

      expect { product.save! }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

  describe 'audited' do
    it 'update' do
      product = FactoryGirl.create(:product)

      expect(product.audits.size).to eq 1
      expect(product.audits.first.action).to eq 'create'
      expect(product.audits.first.version).to eq 1

      product.update_attributes!(brand: 'new brand')

      expect(product.audits.size).to eq 2
      expect(product.audits.last.action).to eq 'update'
      expect(product.audits.last.version).to eq 2
    end

    it 'destroy' do
      product = FactoryGirl.create(:product)

      expect(product.audits.size).to eq 1
      expect(product.audits.first.action).to eq 'create'
      expect(product.audits.first.version).to eq 1

      product.destroy!

      expect(product.audits.size).to eq 2
      expect(product.audits.last.action).to eq 'destroy'
      expect(product.audits.last.version).to eq 2
      expect(Product.all.size).to eq 0
    end
  end

end
