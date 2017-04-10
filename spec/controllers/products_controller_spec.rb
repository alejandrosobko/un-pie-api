require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  before(:each) do
    Time.zone = 'Buenos Aires'

    token = Knock::AuthToken.new(payload: {sub: FactoryGirl.create(:user).id}).token
    @request.headers['Authorization'] = "Bearer #{token}"
  end

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
      FactoryGirl.create(:product, own: true)

      get :index
      json = JSON.parse(response.body)['products']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end

  end

  describe 'POST create' do
    it 'returns 422' do
      params = {brand: 'A brand', article: 'OJ1', color: 'Negro'}
      post :create, params: {product: params}
      json = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json['provider'].first).to eq 'debe existir'
    end

    it 'creates one product' do
      provider = FactoryGirl.create(:provider, name: 'Super calzado')
      purchase_order = {purchase_date: '2017-01-01'}
      params = {brand: 'A brand', article: 'OJ1', color: 'Negro', provider: provider.as_json, purchase_order: purchase_order}
      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(json['article']).to eq 'OJ1'
      expect(json['color']).to eq 'Negro'
    end

    it 'creates a purchase order' do
      provider = FactoryGirl.create(:provider, name: 'Super calzado')
      purchase_order = {purchase_date: '2017-01-01'}
      params = {brand: 'A brand', article: 'OJ1', color: 'Negro', provider: provider.as_json, purchase_order: purchase_order}
      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(PurchaseOrder.all.size).to eq 1
      expect(PurchaseOrder.first.product_attributes['brand']).to eq json['brand']
    end

    describe 'existing products' do
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

      it 'update the purchase price' do
        provider = FactoryGirl.create(:provider, name: 'Bla')
        FactoryGirl.create(:product, brand: 'Brand', article: 'ABC123', size: '40-41', color: 'Black', purchase_price: 10, provider: provider)

        expect(Product.all.size).to eq 1

        params = {brand: 'Brand', article: 'ABC123', size: '40-41', color: 'Black', amount: 3, purchase_price: 20, provider: provider.as_json}

        post :create, params: {product: params}
        json = JSON.parse(response.body)['product']

        expect(Product.all.size).to eq 1
        expect(json['purchase_price']).to eq 20
      end
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

  describe 'add to stock' do
    it 'increase stock and creates a new purchase order' do
      provider = FactoryGirl.create(:provider, name: 'Bla')
      params = {brand: 'Brand', article: 'ABC123', size: '40-41', color: 'Black', amount: 3, purchase_price: 20, provider: provider.as_json}

      post :create, params: {product: params}
      json = JSON.parse(response.body)['product']

      expect(PurchaseOrder.all.size).to eq 1

      params = {amount: 3}
      put :add_to_stock, params: {id: json['id'], product: params}
      json = JSON.parse(response.body)['product']

      expect(json['amount']).to eq 3
      expect(PurchaseOrder.all.size).to eq 2
      expect(PurchaseOrder.last.amount).to eq 3
    end
  end

end
