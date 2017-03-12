class PurchaseOrder < ApplicationRecord
  belongs_to :product, autosave: true
  belongs_to :provider, autosave: true

  validates_presence_of :purchase_date
end
