require 'rails_helper'

RSpec.describe PurchaseOrdersController, type: :controller do

  before(:each) do
    token = Knock::AuthToken.new(payload: {sub: create(:user).id}).token
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
      create(:purchase_order, {product: build(:product)})
      get :index
      json = JSON.parse(response.body)['purchase_orders']

      expect(response.status).to eq 200
      expect(json.size).to eq 1
    end
  end

  describe 'DELETE' do
    it 'destroy purchase order with product not sold' do
      product = create(:product)
      purchase_order = create(:purchase_order, product: product)

      delete :destroy, params: {id: purchase_order.id}

      expect(response.status).to eq 200
      expect(Product.all.size).to eq 0
      expect(PurchaseOrder.all.size).to eq 0
    end

    it 'destroy product and sales' do
      product = create(:product)
      create(:complete_sale, product: product)
      create(:complete_sale, product: product)
      purchase_order = create(:purchase_order, product: product)

      expect(Sale.all.size).to eq 2

      delete :destroy, params: {id: purchase_order.id}

      expect(response.status).to eq 200
      expect(Sale.all.size).to eq 0
      expect(Product.all.size).to eq 0
      expect(PurchaseOrder.all.size).to eq 0
    end

    it 'destroy all purchase orders of the same product' do
      product = create(:product)
      purchase_order_1 = create(:purchase_order, product: product)
      create(:purchase_order, product: product)
      create(:purchase_order, product: product)

      expect(PurchaseOrder.all.size).to eq 3

      delete :destroy, params: {id: purchase_order_1.id}

      expect(response.status).to eq 200
      expect(Product.all.size).to eq 0
      expect(PurchaseOrder.all.size).to eq 0
    end

  end

end
