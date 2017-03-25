require 'rails_helper'

RSpec.describe PurchaseOrder, type: :model do

  describe 'new purchase order' do
    it 'save a new purchase order' do
      purchase_order = FactoryGirl.build(:purchase_order)

      expect(purchase_order.save).to eq true
    end

    it 'does not save without product and provider' do
      purchase_order = PurchaseOrder.new
      purchase_order.purchase_date = Time.zone.now

      expect(purchase_order.save).to eq false
    end

    it 'does not save without purchase date' do
      purchase_order = PurchaseOrder.new
      purchase_order.product = FactoryGirl.build(:product)
      purchase_order.provider = FactoryGirl.build(:provider)

      expect(purchase_order.save).to eq false
    end

    it 'creates two equals purchase orders' do
      product = FactoryGirl.build(:product)
      provider = FactoryGirl.build(:provider)
      time = Time.zone.now
      PurchaseOrder.create!(product: product, provider: provider, purchase_date: time)
      PurchaseOrder.create!(product: product, provider: provider, purchase_date: time)

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
