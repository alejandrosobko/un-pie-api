class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :provider

  validates_presence_of :amount, :product, :provider
end
