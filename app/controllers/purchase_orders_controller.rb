class PurchaseOrdersController < ApplicationController

  # GET /purchase_orders
  def index
    @purchase_orders = PurchaseOrder.all

    render json: @purchase_orders
  end

end
