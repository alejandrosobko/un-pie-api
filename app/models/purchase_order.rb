class PurchaseOrder < ApplicationRecord
  serialize :product_attributes, Hash
  belongs_to :product

  validates_presence_of :purchase_date, :product, :provider_name
  audited

end
