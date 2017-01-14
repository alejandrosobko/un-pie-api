require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe 'GET index' do
    it 'returns an empty list' do
      get :index
      json = JSON.parse(response.body)['data']

      expect(response.status).to eq 200
      expect(json).to eq []
    end

    it 'returns a list with one product' do
      FactoryGirl.create(:product_with_provider)
      get :index
      json = JSON.parse(response.body)['data']

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
      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq '1'
      expect(json['type']).to eq 'products'
      expect(json['attributes']['provider']['id']).to eq 1
    end
  end

  # describe 'POST create' do
  #   it 'creates one product with provider' do
  #     params = {name: 'Ojotas', article: 'OJ1', color: 'Negro', provider: {name: 'Super calzado'}}
  #     post :create, params: {product: params}
  #     json = JSON.parse(response.body)['data']
  #
  #     expect(json['id']).to eq '1'
  #     expect(json['type']).to eq 'products'
  #     expect(json['attributes']['provider']['id']).to eq 1
  #   end
  # end

  describe 'PUT/PATCH update' do
    it 'update product' do
      FactoryGirl.create(:product_with_provider)
      get :show, params: {id: 1}
      json = JSON.parse(response.body)['data']
      expect(json['id']).to eq '1'
      expect(json['color']).to be_nil

      params = {color: 'Black'}
      put :update, params: {id: 1, product: params}
      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq '1'
      expect(json['attributes']['color']).to eq 'Black'
    end

    it 'update amount' do
      FactoryGirl.create(:product_with_provider)
      params = {amount: 3}
      put :update, params: {id: 1, product: params}
      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq '1'
      expect(json['attributes']['amount']).to eq 3
    end
  end


end
