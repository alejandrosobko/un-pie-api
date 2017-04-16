class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :add_to_stock]
  before_action :parse_default_params

  # GET /products
  def index
    @products = Product.where(own: true)

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params) # && updated_purchase_order && updated_stock
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # POST /products
  def create
    @product = find_or_initialize_product
    provider = find_or_initialize_provider
    @product.providers.push(provider) unless exists_provider?

    if @product.save
      create_stock!(provider)
      create_purchase_order!(provider)

      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PUT /products/add_to_stock
  def add_to_stock
    if updated_stock
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

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:brand, :article, :color, :description, :purchase_price, :sale_price, :cash_price, :size, :own)
  end

  def parse_default_params
    return unless params[:product]

    params[:product][:purchase_price] ||= 0.0
    params[:product][:sale_price] ||= 0.0
    params[:product][:cash_price] ||= 0.0
    params[:product][:amount] = params[:product][:amount].to_i
    purchase_date = params[:product][:purchase_date] || Time.zone.now.to_s
    params[:product][:purchase_date] = Time.zone.parse(purchase_date)
  end

  def find_or_initialize_product
    product = Product.find_or_initialize_by(brand: product_params[:brand], article: product_params[:article],
                                            size: product_params[:size], color: product_params[:color])
    product.assign_attributes(product_params)
    product
  end

  def find_or_initialize_provider
    raise "provider can't be blank" unless params[:product][:provider]

    exists_provider? ||
      Provider.find_or_initialize_by(name: params[:product][:provider][:name])
  end

  def exists_provider?
    @product.providers.find { |prov| prov.name == params[:product][:provider][:name] }
  end

  def create_stock!(provider)
    stock = Stock.find_or_initialize_by(product_id: @product.id, provider_id: provider.id)
    stock.amount += params[:product].fetch(:amount, 0)
    stock.save!
  end

  def create_purchase_order!(provider)
    purchase_order = PurchaseOrder.new
    purchase_order.purchase_date = params[:product][:purchase_date]
    purchase_order.product_attributes = @product.attributes
    purchase_order.provider_name = provider.name
    purchase_order.amount = params[:product][:amount]
    purchase_order.save!
  end

  def updated_stock
    stock = Stock.find_by(product_id: @product.id, provider_id: params[:provider][:id])
    stock.amount += params[:product][:amount]
    stock.save!
    create_purchase_order!(stock.provider)
  end

end
