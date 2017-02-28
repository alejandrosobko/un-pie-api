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

    it 'returns a list with one product' do
      FactoryGirl.create(:product)
      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns one product with provider' do
      product = FactoryGirl.create(:product)
      get :show, params: { id: product.id }
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq product.id
      expect(json['provider']['id']).to eq product.provider.id
    end
  end

  describe 'POST create' do
    it 'returns 422' do
      params = {article: 'OJ1', color: 'Negro'}
      post :create, params: {product: params}
      json = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json['provider'].first).to eq 'must exist'
      expect(json['provider'][1]).to eq 'debe existir'
    end

    it 'creates one product' do
      provider = FactoryGirl.create(:provider, name: 'Super calzado')
      time = '2017-01-01'
      params = {article: 'OJ1', color: 'Negro', provider: provider.as_json, purchase_date: time}
      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(json['article']).to eq 'OJ1'
      expect(json['color']).to eq 'Negro'
      expect(json['provider']['name']).to eq 'Super calzado'
    end

    it 'creates a purchase order' do
      provider = FactoryGirl.create(:provider, name: 'Super calzado')
      params = {article: 'OJ1', color: 'Negro', provider: provider.as_json, purchase_date: '2017-01-01'}
      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(PurchaseOrder.all.size).to eq 1
      expect(PurchaseOrder.first.product.id).to eq json['id']
      expect(PurchaseOrder.first.purchase_date).to eq Time.new('2017-01-01')
    end

    it 'should increase the amount, and not create other one' do
      provider = FactoryGirl.create(:provider, name: 'Bla')
      FactoryGirl.create(:product, brand: 'Brand', article: 'ABC123', size: '40-41', color: 'Black', amount: 3, provider: provider)

      expect(Product.all.size).to eq 1

      params = {brand: 'Brand', article: 'ABC123', size: '40-41', color: 'Black', amount: 3, provider: provider.as_json}

      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(Product.all.size).to eq 1
      expect(json['amount']).to eq 6
    end
  end

  describe 'PUT/PATCH update' do
    it 'update product' do
      product = FactoryGirl.create(:product)
      get :show, params: {id: product.id}
      json = JSON.parse(response.body)['product']
      expect(json['id']).to eq product.id
      expect(json['color']).to be_nil

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
