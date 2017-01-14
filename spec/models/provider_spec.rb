require 'rails_helper'

RSpec.describe Provider, type: :model do

  describe 'new provider' do
    it 'should can save an empty provider' do
      provider = Provider.new

      expect(provider.save).to eq true
    end

    it 'returns a list of products' do
      provider = Provider.new

      expect(provider.products).to eq []
    end
  end

end
