class ProviderSerializer < ActiveModel::Serializer
  attributes :id, :name, :products, :stocks

  def products
    @object.products.map do |product|
      product_json = product.as_json
      product_json[:amount] = nil
      product_json
    end
  end
end
