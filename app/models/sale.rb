class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :provider
  validates_presence_of :sale_date, :sale_price, :product, :provider

  def as_json(args)
    json = super(args)
    json[:product] = product.as_json
    json[:provider] = provider.as_json
    json
  end
end
