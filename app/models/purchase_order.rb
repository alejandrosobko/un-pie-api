class PurchaseOrder < ApplicationRecord
  belongs_to :product

  validates_presence_of :purchase_date
end
