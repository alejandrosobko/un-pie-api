require 'rails_helper'

RSpec.describe SalesController, type: :controller do

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['sales']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one sale' do
      FactoryGirl.create(:complete_sale)
      get :index
      json = JSON.parse(response.body)['sales']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'POST index' do
    it 'creates a sale' do
      product = FactoryGirl.create(:product_with_provider)

      params = {sale: {sale_price: 120, sale_date: '20/01/2016', product_id: product.id}}
      post :create, params: params
      json = JSON.parse(response.body)['sale']

      expect(json['product_id']).to eq product.id
      expect(json['sale_price']).to eq 120
      expect(json['sale_date']).to eq '2016-01-20T00:00:00.000-03:00'
    end

    it 'reduces the amount of the product sold' do
      product = FactoryGirl.create(:product_with_provider, amount: 3)
      params = {sale: {sale_price: 120, sale_date: '20/01/2016', product_id: product.id}}
      post :create, params: params

      expect(Product.find(product.id).amount).to eq 2
    end
  end

end
