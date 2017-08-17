class PurchaseOrdersController < ApplicationController

  # GET /purchase_orders
  def index
    @purchase_orders = PurchaseOrder.all

    render json: @purchase_orders
  end

  # DELETE /purchase_orders/1
  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    begin
      destroy_all!

      render json: {success: true, status: :deleted}
    rescue StandardError => e
      render json: {error: true}
    end
  end

  def logs
    logs = PurchaseOrder.all.map(&:audits).flatten

    render json: {logs: logs}
  end

  private

  def destroy_all!
    Sale.where(product_id: @purchase_order.product.id).destroy_all
    @purchase_order.product.destroy!
  end

end

