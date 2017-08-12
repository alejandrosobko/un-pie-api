class PurchaseOrderSerializer < ActiveModel::Serializer
  attributes :id, :purchase_date, :amount, :product, :provider_name
end
