require 'rails_helper'

RSpec.describe PurchaseOrdersController, type: :controller do

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

end
