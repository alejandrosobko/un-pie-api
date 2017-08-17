require 'rails_helper'

RSpec.describe Sale, type: :model do

  describe 'new sale' do
    it 'should not create an empty sale' do
      sale = Sale.new

      expect(sale.save).to eq false
    end

    it 'create a sale' do
      sale = Sale.new
      sale.product = build(:product)
      sale.sale_date = DateTime.now.in_time_zone
      sale.sale_price = 120

      expect(sale.save).to eq true
    end
  end
end
