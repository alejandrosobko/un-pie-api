class ProviderSerializer < ActiveModel::Serializer
  attributes :id, :name, :products

  def products
    @object.products.map do |product|
      product_json = product.as_json
      product_json[:amount] = Stock.find_by(product_id: product.id, provider_id: @object.id).amount
      product_json
    end
  end
end
