class ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]
  before_action :parse_default_params

  # GET /products
  def index
    # @products = joined_products(Product.where(own: true))
    @products = Product.where(own: true)

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def logs
    logs = Product.all.map(&:audits).flatten

    render json: {logs: logs}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:brand, :article, :color, :description, :purchase_price, :sale_price, :cash_price,
                                    :size, :amount, :own)
  end

  def parse_default_params
    return unless params[:product]
    params[:product][:amount]         ||= 0
    params[:product][:purchase_price] ||= 0.0
    params[:product][:sale_price]     ||= 0.0
    params[:product][:cash_price]     ||= 0.0
    purchase_date = params[:product][:purchase_date] || Time.zone.now.to_s
    params[:product][:purchase_date] = Time.zone.parse(purchase_date)
  end

  # Mover a un servicio

  def joined_products(products)
    result = []

    products.each do |p|
      similar = similar_product(p, result)

      if similar
        p.amount = p.amount + similar.amount
      else
        result.push(p)
      end
    end

    result
  end

  def similar_product(product, products)
    products.find { |p| similar_attributes(p, product) }
  end

  def similar_attributes(product1, product2)
    product1.brand.to_s     == product2.brand.to_s   &&
      product1.article.to_s == product2.article.to_s &&
      product1.size.to_s    == product2.size.to_s    &&
      product1.color.to_s   == product2.color.to_s
  end

  # fin servicio

end
