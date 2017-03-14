class PurchaseOrdersController < ApplicationController

  before_action :parse_params

  # GET /purchase_orders
  def index
    @purchase_orders = PurchaseOrder.all

    render json: @purchase_orders
  end

  # POST /purchase_order
  def create
    @purchase_order = initialize_purchase_order

    if @purchase_order.save
      render json: @purchase_order, status: :created, location: @purchase_order
    else
      render json: @purchase_order.errors, status: :unprocessable_entity
    end
  end

  def logs
    logs = PurchaseOrder.all.map { |purchase_order| purchase_order.audits }.flatten

    render json: {logs: logs}
  end

  private

  def parse_params # TODO: Arreglar el serializer y eliminar esto
    params[:purchase_order] = params[:purchaseOrder] if params[:purchaseOrder]
  end

  def product_params
    params.require(:purchase_order).require(:product).permit(:brand, :article, :color, :description, :purchase_price, :sale_price, :cash_price,
                                                             :size, :amount, :own)
  end

  def provider_params
    params.require(:purchase_order).require(:provider).permit(:name)
  end

  def find_or_initialize_product
    return unless product_params

    product = Product.find_by({brand: product_params[:brand], article: product_params[:article],
                               size: product_params[:size], color: product_params[:color]})

    if product
      # product.providers.push(find_or_initialize_provider) unless contains_provider?(product)
      product.purchase_price = product_params[:purchase_price].to_i
      product.amount += product_params[:amount].to_i
      product.own = true
      product
    else
      Product.new(product_params)
    end
  end

  def find_or_initialize_provider
    return unless params[:purchase_order][:provider]
    Provider.find_or_initialize_by(name: params[:purchase_order][:provider][:name])
  end

  def initialize_purchase_order
    date = params[:purchase_order][:purchase_date] || Time.zone.now.to_s
    purchase_order = PurchaseOrder.new
    purchase_order.purchase_date = Time.parse(date)
    purchase_order.product = find_or_initialize_product
    purchase_order.provider = find_or_initialize_provider
    purchase_order
  end

  def contains_provider?(product)
    product.providers.any? { |provider| provider.name == params[:purchase_order][:provider][:name] }
  end

end

