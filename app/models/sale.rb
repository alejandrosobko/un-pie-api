class Sale < ApplicationRecord
  belongs_to :product
  validates_presence_of :sale_date, :sale_price
end
