require 'rails_helper'

RSpec.describe Stock, type: :model do

  describe 'new stock' do
    it 'should not save' do
      stock = Stock.new
      expect(stock.save).to eq false
    end

    it 'should save' do
      stock = Stock.new
      stock.product = build(:product)
      stock.provider = build(:provider)
      stock.amount = 5

      expect(stock.save).to eq true
    end
  end

end
