require 'rails_helper'

RSpec.describe Provider, type: :model do

  describe 'new provider' do
    it 'should not can save an empty provider' do
      provider = Provider.new

      expect(provider.save).to eq false
    end

    it 'creates a provider with name' do
      provider = Provider.new(name: 'Some name')

      expect(provider.save).to eq true
    end

    it 'should raise exception' do
      provider = Provider.new
      provider.name = 'Some name'
      provider.save!

      provider2 = Provider.new
      provider2.name = 'Some name'
      expect { provider2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'audited' do
    it 'update' do
      provider = FactoryGirl.create(:provider)

      expect(provider.audits.size).to eq 1
      expect(provider.audits.first.action).to eq 'create'
      expect(provider.audits.first.version).to eq 1

      provider.update_attributes!(name: 'new name')

      expect(provider.audits.size).to eq 2
      expect(provider.audits.last.action).to eq 'update'
      expect(provider.audits.last.version).to eq 2
    end

    it 'destroy' do
      provider = FactoryGirl.create(:provider)

      expect(provider.audits.size).to eq 1
      expect(provider.audits.first.action).to eq 'create'
      expect(provider.audits.first.version).to eq 1

      provider.destroy!

      expect(provider.audits.size).to eq 2
      expect(provider.audits.last.action).to eq 'destroy'
      expect(provider.audits.last.version).to eq 2
      expect(Product.all.size).to eq 0
    end
  end
end
