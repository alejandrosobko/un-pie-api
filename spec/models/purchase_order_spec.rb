require 'rails_helper'

RSpec.describe PurchaseOrder, type: :model do

  describe 'new purchase order' do
    it 'save a new purchase order' do
      purchase_order = FactoryGirl.build(:purchase_order)

      expect(purchase_order.save).to eq true
    end

    it 'does not save without product' do
      purchase_order = PurchaseOrder.new
      purchase_order.purchase_date = Time.zone.now

      expect(purchase_order.save).to eq false
    end

    it 'does not save without purchase date' do
      purchase_order = PurchaseOrder.new
      purchase_order.product = FactoryGirl.build(:product)

      expect(purchase_order.save).to eq false
    end

    it 'creates two equals purchase orders' do
      product = FactoryGirl.build(:product)
      time = Time.zone.now
      purchase_order1 = PurchaseOrder.create!({product: product, purchase_date: time})
      purchase_order2 = PurchaseOrder.create!({product: product, purchase_date: time})

      expect(PurchaseOrder.all.size).to eq 2
    end
  end

end
