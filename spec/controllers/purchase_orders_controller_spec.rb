require 'rails_helper'

RSpec.describe PurchaseOrdersController, type: :controller do

  before(:each) do
    token = Knock::AuthToken.new(payload: {sub: FactoryGirl.create(:user).id}).token
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['purchase_orders']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one purchase order' do
      FactoryGirl.create(:purchase_order)
      get :index
      json = JSON.parse(response.body)['purchase_orders']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'POST create' do
    it 'creates a purchase order' do
      product = FactoryGirl.attributes_for(:product)
      provider = FactoryGirl.attributes_for(:provider)
      time = Time.zone.now
      params = {purchase_order: {product: product, provider: provider, purchase_date: time.to_s}}

      post :create, params: params

      expect(response.status).to eq 201
      expect(PurchaseOrder.all.size).to eq 1
      expect(Product.all.size).to eq 1
      expect(Provider.all.size).to eq 1
      expect(Product.first.brand).to eq product[:brand]
      expect(Provider.first.name).to eq provider[:name]
    end

    it 'increases the amount, and not create other one' do
      product = FactoryGirl.attributes_for(:product, {amount: 2})
      provider = FactoryGirl.attributes_for(:provider)
      time = Time.zone.now
      params = {purchase_order: {product: product, provider: provider, purchase_date: time.to_s}}
      post :create, params: params

      product2 = FactoryGirl.attributes_for(:product, {amount: 2})
      params = {purchase_order: {product: product2, provider: provider, purchase_date: time.to_s}}
      post :create, params: params

      expect(PurchaseOrder.all.size).to eq 2
      expect(Product.all.size).to eq 1
      expect(Product.first.amount).to eq 4
      expect(Provider.all.size).to eq 1
    end

    it 'update the purchase price' do
      product = FactoryGirl.attributes_for(:product, {purchase_price: 50})
      provider = FactoryGirl.attributes_for(:provider)
      time = Time.zone.now
      params = {purchase_order: {product: product, provider: provider, purchase_date: time.to_s}}
      post :create, params: params

      product2 = FactoryGirl.attributes_for(:product, {purchase_price: 100})
      params = {purchase_order: {product: product2, provider: provider, purchase_date: time.to_s}}
      post :create, params: params

      expect(PurchaseOrder.all.size).to eq 2
      expect(Product.all.size).to eq 1
      expect(Product.first.purchase_price).to eq 100
    end
  end

end
