class Sale < ApplicationRecord
  has_one :product
  validates_presence_of :product_id, :sale_date, :sale_price
end
