require 'rails_helper'

RSpec.describe PurchaseOrder, type: :model do

  describe 'new purchase order' do
    it 'save a new purchase order' do
      purchase_order = FactoryGirl.build(:purchase_order)

      expect(purchase_order.save).to eq true
    end

    it 'does not save without product attributes' do
      purchase_order = PurchaseOrder.new
      purchase_order.purchase_date = Time.zone.now

      expect(purchase_order.save).to eq false
    end

    it 'does not save without purchase date' do
      purchase_order = PurchaseOrder.new
      purchase_order.product_attributes = FactoryGirl.attributes_for(:product)

      expect(purchase_order.save).to eq false
    end

    it 'creates two equals purchase orders' do
      product_attributes = FactoryGirl.attributes_for(:product)
      time = Time.zone.now
      PurchaseOrder.create!(product_attributes: product_attributes, purchase_date: time, provider_name: 'Ale')
      PurchaseOrder.create!(product_attributes: product_attributes, purchase_date: time, provider_name: 'Ale')

      expect(PurchaseOrder.all.size).to eq 2
    end
  end

  describe 'audited' do
    it 'update' do
      purchase_order = FactoryGirl.create(:purchase_order)

      expect(purchase_order.audits.size).to eq 1
      expect(purchase_order.audits.first.action).to eq 'create'
      expect(purchase_order.audits.first.version).to eq 1

      purchase_order.update_attributes!(purchase_date: Time.zone.now)

      expect(purchase_order.audits.size).to eq 2
      expect(purchase_order.audits.last.action).to eq 'update'
      expect(purchase_order.audits.last.version).to eq 2
    end

    it 'destroy' do
      purchase_order = FactoryGirl.create(:purchase_order)

      expect(purchase_order.audits.size).to eq 1
      expect(purchase_order.audits.first.action).to eq 'create'
      expect(purchase_order.audits.first.version).to eq 1

      purchase_order.destroy!

      expect(purchase_order.audits.size).to eq 2
      expect(purchase_order.audits.last.action).to eq 'destroy'
      expect(purchase_order.audits.last.version).to eq 2
      expect(PurchaseOrder.all.size).to eq 0
    end
  end
end
