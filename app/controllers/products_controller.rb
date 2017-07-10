class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :add_to_stock]
  before_action :parse_default_params

  # GET /products
  def index
    @products = Product.where(own: true)

    render json: {products: @products}
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

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.provider = find_or_initialize_provider

    if @product.save
      create_purchase_order!

      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PUT /products/add_to_stock
  def add_to_stock
    amount = @product.amount + params[:product][:amount]

    if @product.update(amount: amount, own: true)
      create_purchase_order!

      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def logs
    if (params[:from] || params[:to]).present?
      logs = find_logs_by_date
    else
      logs = Product.all.map(&:audits).flatten
    end

    render json: {logs: logs}
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:brand, :article, :color, :description, :purchase_price, :credit_card_price, :cash_price,
                                    :size, :amount, :own)
  end

  def parse_default_params
    return unless params[:product]

    params[:product][:brand]   = params[:product][:brand].capitalize if params[:product][:brand]
    params[:product][:color]   = params[:product][:color].capitalize if params[:product][:color]
    params[:product][:brand]   = params[:product][:brand].capitalize if params[:product][:brand]
    params[:product][:article] = params[:product][:article].upcase   if params[:product][:article]
    params[:product][:amount]  = params[:product][:amount].to_i
    params[:product][:purchase_price]    ||= 0.0
    params[:product][:credit_card_price] ||= 0.0
    params[:product][:cash_price]        ||= 0.0
    purchase_date = params[:product][:purchase_date] || Time.zone.now.to_s
    params[:product][:purchase_date] = Time.zone.parse(purchase_date)
  end

  def find_or_initialize_provider
    return unless params[:product][:provider]
    Provider.find_or_initialize_by(name: params[:product][:provider][:name])
  end

  def create_purchase_order!
    date = params[:product].fetch(:purchase_date, Time.zone.now).to_s
    purchase_order = PurchaseOrder.new
    purchase_order.purchase_date = Time.parse(date)
    purchase_order.product_attributes = @product.attributes
    purchase_order.provider_name = @product.provider.name
    purchase_order.amount = params[:product][:amount]
    purchase_order.save!
  end

  def find_logs_by_date
    from = Time.zone.parse(params[:from])
    to = Time.zone.parse(params[:to])

    Product.where('created_at >= ? AND updated_at <= ?', from, to).map(&:audits).flatten
  end

end
