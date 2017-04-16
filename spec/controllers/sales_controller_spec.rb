require 'rails_helper'

RSpec.describe SalesController, type: :controller do

  before(:each) do
    token = Knock::AuthToken.new(payload: {sub: FactoryGirl.create(:user).id}).token
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['sales']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one sale' do
      FactoryGirl.create(:sale, provider: build(:provider)) # todo: no se por que no puedo usar el provider del factory de sale, falla la validacion del provider
      get :index
      json = JSON.parse(response.body)['sales']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'POST index' do
    it 'creates a sale' do
      product = FactoryGirl.create(:product, providers: [FactoryGirl.create(:provider)])
      provider = product.providers.first
      Stock.find_by(product_id: product.id, provider_id: provider.id).update_attribute(:amount, 3)

      params = {sale: {sale_price: 120, sale_date: '20/01/2016', product: product.as_json, provider: provider.as_json}}
      post :create, params: params
      json = JSON.parse(response.body)['sale']

      expect(json['product']['id']).to eq product.id
      expect(json['sale_price']).to eq 120
      expect(json['sale_date']).to eq '2016-01-20T00:00:00.000-03:00'
    end

    it 'reduces the amount of the sold product' do
      product = FactoryGirl.create(:product, providers: [FactoryGirl.create(:provider)])
      provider = product.providers.first
      Stock.find_by(product_id: product.id, provider_id: provider.id).update_attribute(:amount, 3)

      params = {sale: {sale_price: 120, sale_date: '20/01/2016', product: product.as_json, provider: provider.as_json}}
      post :create, params: params

      expect(Stock.find_by(product_id: product.id, provider_id: provider.id).amount).to eq 2
    end
  end

end
