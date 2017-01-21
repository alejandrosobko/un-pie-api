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
    it 'throw ActiveRecord::RecordNotFound' do
      request = Proc.new{ get :show, params: { id: 1 } }

      expect {request.call}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns one provider' do
      FactoryGirl.create(:provider)
      get :show, params: { id: 1 }
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq 1
      expect(json['products']).to eq []
    end

    it 'returns one provider with products' do
      FactoryGirl.create(:product_with_provider)

      get :show, params: { id: 1 }
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq 1
      expect(json['products'].first['id']).to eq 1
    end
  end

  describe 'POST create' do
    it 'creates one provider' do
      params = {provider: {name: 'Super calzado'}}
      post :create, params: params
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq 1
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
      FactoryGirl.create(:product_with_provider)
      get :show, params: {id: 1}
      json = JSON.parse(response.body)['provider']
      expect(json['id']).to eq 1
      expect(json['name']).to eq 'Some name'

      params = {name: 'New name'}
      put :update, params: {id: 1, provider: params}
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq 1
      expect(json['name']).to eq 'New name'
    end
  end

end
