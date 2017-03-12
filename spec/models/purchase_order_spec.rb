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
      purchase_order1 = PurchaseOrder.create!({product: product, provider: provider, purchase_date: time})
      purchase_order2 = PurchaseOrder.create!({product: product, provider: provider, purchase_date: time})

      expect(PurchaseOrder.all.size).to eq 2
    end
  end

end
