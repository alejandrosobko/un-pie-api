require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one product' do
      FactoryGirl.create(:product_with_provider)
      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'throw ActiveRecord::RecordNotFound' do
      request = Proc.new{ get :show, params: { id: 1 } }

      expect {request.call}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns one product with provider' do
      FactoryGirl.create(:product_with_provider)
      get :show, params: { id: 1 }
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq 1
      expect(json['provider']['id']).to eq 1
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
      params = {article: 'OJ1', color: 'Negro', provider: provider.as_json}
      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(json['article']).to eq 'OJ1'
      expect(json['color']).to eq 'Negro'
      expect(json['provider']['name']).to eq 'Super calzado'
    end
  end

  describe 'PUT/PATCH update' do
    it 'update product' do
      FactoryGirl.create(:product_with_provider)
      get :show, params: {id: 1}
      json = JSON.parse(response.body)['product']
      expect(json['id']).to eq 1
      expect(json['color']).to be_nil

      params = {color: 'Black'}
      put :update, params: {id: 1, product: params}
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq 1
      expect(json['color']).to eq 'Black'
    end

    it 'update amount' do
      FactoryGirl.create(:product_with_provider)
      params = {amount: 3}
      put :update, params: {id: 1, product: params}
      json = JSON.parse(response.body)['product']

      expect(json['id']).to eq 1
      expect(json['amount']).to eq 3
    end
  end

  it 'should increase the amount, and not create other one' do
    product = FactoryGirl.create(:product_with_provider, brand: 'Brand', article: 'ABC123', amount: 3)

    expect(Product.all.size).to eq 1

    provider = FactoryGirl.create(:provider, name: 'Bla')
    params = {brand: 'Brand', article: 'ABC123', amount: 3, provider: provider.as_json}

    post :create, params: {product: params}
    json = JSON.parse(response.body)['product']

    expect(Product.all.size).to eq 1
    expect(json['amount']).to eq 6
  end



end
