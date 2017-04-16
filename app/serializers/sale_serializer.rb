class SaleSerializer < ActiveModel::Serializer
  attributes :id, :sale_date, :sale_price
  belongs_to :product
  belongs_to :provider
end
