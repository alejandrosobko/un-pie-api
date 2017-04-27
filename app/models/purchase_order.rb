class PurchaseOrder < ApplicationRecord
  validates_presence_of :purchase_date, :product_attributes, :provider_name

  serialize :product_attributes
  audited

end
