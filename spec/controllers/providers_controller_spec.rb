require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do

  before(:each) do
    token = Knock::AuthToken.new(payload: {sub: FactoryGirl.create(:user).id}).token
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
      FactoryGirl.create(:provider)
      get :index
      json = JSON.parse(response.body)['providers']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'PUT/PATCH update' do
    it 'update the provider name' do
      provider = FactoryGirl.create(:provider)

      expect(Provider.all.size).to eq 1

      params = {name: 'New name'}
      put :update, params: {id: provider.id, provider: params}
      json = JSON.parse(response.body)['provider']

      expect(json['id']).to eq provider.id
      expect(json['name']).to eq 'New name'
    end
  end

end
