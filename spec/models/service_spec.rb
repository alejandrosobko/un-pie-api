require 'rails_helper'

RSpec.describe Service, type: :model do

  describe 'new' do
    it 'should not creates an empty service' do
      service = Service.new

      expect(service.save).to eq false
    end

    it 'creates a complete service' do
      payment_date = DateTime.now
      service = Service.new({name: 'Gas', cost: 200.50, payment_date: payment_date})

      expect(service.save).to eq true
      expect(service.cost).to eq 200.50
      expect(service.payment_date).to eq payment_date
    end
  end

end
