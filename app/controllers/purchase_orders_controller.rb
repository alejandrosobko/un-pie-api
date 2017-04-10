class PurchaseOrdersController < ApplicationController

  # GET /purchase_orders
  def index
    @purchase_orders = PurchaseOrder.all

    render json: @purchase_orders
  end

  def logs
    logs = PurchaseOrder.all.map(&:audits).flatten

    render json: {logs: logs}
  end

end

