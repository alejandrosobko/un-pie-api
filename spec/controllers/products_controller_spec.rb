require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  before(:each) { Time.zone = 'Buenos Aires' }

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list without own products' do
      FactoryGirl.create(:product)
      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json.size).to eq 0
    end

    it 'returns a list with one own products' do
      product = FactoryGirl.create(:product, {own: true})
      provider = FactoryGirl.create(:provider)
      FactoryGirl.create(:purchase_order, {product: product, provider: provider})

      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end

  end

  describe 'PUT/PATCH update' do
    it 'update product' do
      product = FactoryGirl.create(:product)
      expect(Product.find(product.id).color).to be_nil

      params = {color: 'Black'}
      put :update, params: {id: product.id, product: params}
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq product.id
      expect(json['color']).to eq 'Black'
    end

    it 'update amount' do
      product = FactoryGirl.create(:product)
      params = {amount: 3}
      put :update, params: {id: product.id, product: params}
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq product.id
      expect(json['amount']).to eq 3
    end
  end

end
