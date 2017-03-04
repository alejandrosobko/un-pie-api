class SalesController < ApplicationController

  # GET /sales
  def index
    @sales = Sale.all

    render json: @sales
  end

  # GET /sales/1
  def show
    @sale = Sale.find(params[:id])
    render json: @sale
  end

  # POST /sales
  def create
    create_sale

    if @sale.save
      render json: @sale, status: :created, location: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  private

  def sale_params
    params.require(:sale).permit(:sale_date, :sale_price, :product_id)
  end

  def create_sale
    @sale = Sale.new(sale_params)
    @sale.product_id = sale_params[:product_id]
    @sale.sale_date = Time.zone.parse(sale_params[:sale_date] || Time.zone.now)
    reduce_product_amount
  end

  def reduce_product_amount
    product = Product.find(@sale.product_id)
    product.amount -= 1
    product.save!
  end

end
