class ProductSerializer < ActiveModel::Serializer
  attributes :id, :brand, :article, :color, :description, :purchase_price, :credit_card_price, :cash_price, :size, :amount, :own
end
