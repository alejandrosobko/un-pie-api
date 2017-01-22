class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = find_or_create_product

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    parse_default_params
    params.require(:product).permit(:brand, :article, :color, :description, :purchase_price, :sale_price, :cash_price,
                                    :size, :amount, :own, :provider)
  end

  def parse_default_params
    return unless params[:product]
    params[:product][:amount] ||= 0
    params[:product][:purchase_price] ||= 0.0
    params[:product][:sale_price] ||= 0.0
    params[:product][:cash_price] ||= 0.0
  end

  def find_or_create_provider
    return unless params[:product][:provider]
    Provider.find_or_create_by!(name: params[:product][:provider][:name])
  end

  def find_or_create_product
    product = Product.find_by({brand: params[:product][:brand], article: params[:product][:article]})
    if product
      product.amount += params[:product][:amount].to_i
    else
      product = Product.new(product_params)
      product.provider = find_or_create_provider
    end
    product
  end
end
