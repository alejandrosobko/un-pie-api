class ProductSerializer < ActiveModel::Serializer
  attributes :id, :brand, :article, :color, :description, :purchase_price, :sale_price, :cash_price, :size, :amount,
             :own, :providers
end
