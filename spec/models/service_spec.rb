require 'rails_helper'

RSpec.describe Service, type: :model do

  describe 'new' do
    it 'should not creates an empty service' do
      service = Service.new

      expect(service.save).to eq false
    end

    it 'creates a complete service' do
      payment_date = DateTime.now
      due_date = payment_date + 2.day
      service = Service.new({name: 'Gas', cost: 200.50, payment_date: payment_date, due_date: due_date})

      expect(service.save).to eq true
      expect(service.cost).to eq 200.50
      expect(service.payment_date).to eq payment_date
      expect(service.due_date).to eq due_date
    end

    it 'should not create a service with due date equals than payment date' do
      date = DateTime.now
      service = Service.new({name: 'Gas', cost: 200.50, payment_date: date, due_date: date})

      expect(service.save).to eq false
    end

    it 'should not create a service with due date less than payment date' do
      date = DateTime.now
      service = Service.new({name: 'Gas', cost: 200.50, payment_date: date, due_date: date - 1.day})

      expect(service.save).to eq false
    end
  end

end
