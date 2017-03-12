class SaleSerializer < ActiveModel::Serializer
  attributes :id, :sale_date, :sale_price, :product
end
