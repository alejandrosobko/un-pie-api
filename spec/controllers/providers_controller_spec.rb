require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['providers']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one provider' do
      FactoryGirl.create(:provider)
      get :index
      json = JSON.parse(response.body)['providers']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns one provider' do
      provider = FactoryGirl.create(:provider)
      get :show, params: { id: provider.id }
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq provider.id
      expect(json['products']).to eq []
    end

    it 'returns one provider with products' do
      product = FactoryGirl.create(:product_with_provider)

      get :show, params: { id: product.provider.id }
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq product.provider.id
      expect(json['products']).not_to be_empty
    end
  end

  describe 'POST create' do
    it 'creates one provider' do
      params = {provider: {name: 'Super calzado'}}
      post :create, params: params
      json = JSON.parse(response.body)['provider']

      expect(json['products']).to eq []
    end

    it 'returns 422' do
      FactoryGirl.create(:provider, name: 'Some name')

      params = {provider: {name: 'Some name'}}
      post :create, params: params
      json = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json['name'].first).to eq 'debe ser único'
    end
  end

  describe 'PUT/PATCH update' do
    it 'update the provider name' do
      product = FactoryGirl.create(:product_with_provider)
      get :show, params: {id: product.provider.id}
      json = JSON.parse(response.body)['provider']
      expect(json['id']).to eq product.provider.id
      expect(json['name']).to eq 'Some name'

      params = {name: 'New name'}
      put :update, params: {id: product.provider.id, provider: params}
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq product.provider.id
      expect(json['name']).to eq 'New name'
    end
  end

end
