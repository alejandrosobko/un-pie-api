class ProviderSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :products, each_serializer: ProductSerializer

end
