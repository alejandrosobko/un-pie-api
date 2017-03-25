class Sale < ApplicationRecord
  belongs_to :product
  validates_presence_of :sale_date, :sale_price

  def as_json(args)
    json = super(args)
    json[:product] = product.as_json
    json
  end
end
