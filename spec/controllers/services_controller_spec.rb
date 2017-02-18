require 'rails_helper'

RSpec.describe ServicesController, type: :controller do

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['services']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one service' do
      FactoryGirl.create(:service)
      get :index
      json = JSON.parse(response.body)['services']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'POST index' do
    it 'creates a service' do
      payment_date = '01-12-2017'
      params = {service: {name: 'Gas', cost: 120, payment_date: payment_date}}
      post :create, params: params
      json = JSON.parse(response.body)['service']

      expect(json['cost']).to eq 120
      expect(json['payment_date']).to eq '2017-12-01T00:00:00.000-03:00'
    end

    it 'does not create a service' do
      params = {service: {name: 'Gas', cost: 120}}
      post :create, params: params
      json = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(json['payment_date']).to eq ["can't be blank"]
    end

  end
end
