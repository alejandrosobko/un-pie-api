class PurchaseOrder < ApplicationRecord
  serialize :product_attributes

  validates_presence_of :purchase_date, :product_attributes, :provider_name
  audited

end
