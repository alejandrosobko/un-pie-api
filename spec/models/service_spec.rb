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

  describe 'audited' do
    it 'update' do
      service = FactoryGirl.create(:service)

      expect(service.audits.size).to eq 1
      expect(service.audits.first.action).to eq 'create'
      expect(service.audits.first.version).to eq 1

      service.update_attributes!(payment_date: Time.zone.now)

      expect(service.audits.size).to eq 2
      expect(service.audits.last.action).to eq 'update'
      expect(service.audits.last.version).to eq 2
    end

    it 'destroy' do
      service = FactoryGirl.create(:service)

      expect(service.audits.size).to eq 1
      expect(service.audits.first.action).to eq 'create'
      expect(service.audits.first.version).to eq 1

      service.destroy!

      expect(service.audits.size).to eq 2
      expect(service.audits.last.action).to eq 'destroy'
      expect(service.audits.last.version).to eq 2
      expect(Service.all.size).to eq 0
    end
  end
end
