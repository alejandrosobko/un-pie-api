require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do

  before(:each) do
    token = Knock::AuthToken.new(payload: {sub: create(:user).id}).token
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['providers']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one provider' do
      create(:provider)
      get :index
      json = JSON.parse(response.body)['providers']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'PUT/PATCH update' do
    it 'update the provider name' do
      provider = create(:provider)

      expect(Provider.all.size).to eq 1

      params = {name: 'New name'}
      put :update, params: {id: provider.id, provider: params}
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq provider.id
      expect(json['name']).to eq 'New name'
    end
  end

  describe 'POST remove_product' do
    it 'removes one product without destroy it' do
      product = create(:product)
      provider = product.provider

      expect(provider.products.size).to eq 1

      post :remove_product, params: {id: provider.id, product_id: product.id}

      expect(response.status).to eq 200
      expect(provider.products.size).to eq 0
      expect(product).to_not be_nil
    end
  end

end
