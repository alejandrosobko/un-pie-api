class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :provider
  validates_presence_of :sale_date, :sale_price, :product, :provider

end
