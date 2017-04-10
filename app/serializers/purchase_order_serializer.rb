class PurchaseOrderSerializer < ActiveModel::Serializer
  attributes :id, :purchase_date, :amount, :product_attributes, :provider_name
end
