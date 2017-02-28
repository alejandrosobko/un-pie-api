class PurchaseOrderSerializer < ActiveModel::Serializer
  attributes :id, :purchase_date
  belongs_to :product
end
