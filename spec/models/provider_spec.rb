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

    it 'returns a list of products' do
      provider = Provider.new

      expect(provider.products).to eq []
    end

    it 'should raise exception' do
      provider = Provider.new
      provider.name = 'Some name'
      provider.save!

      provider2 = Provider.new
      provider2.name = 'Some name'
      expect{provider2.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
