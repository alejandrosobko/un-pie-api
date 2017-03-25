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

  # GET /sales/earnings
  def earnings
    @sales = sales_in_range

    render json: {sales: @sales}
  end

  private

  def sale_params
    params.require(:sale).permit(:sale_date, :sale_price)
  end

  def create_sale
    @sale = Sale.new
    @sale.product = Product.find(params[:sale][:product][:id])
    @sale.sale_date = Time.zone.parse(sale_params[:sale_date] || Time.zone.now)
    @sale.sale_price = sale_params[:sale_price]

    reduce_product_amount
  end

  def reduce_product_amount
    @sale.product.amount -= 1
    @sale.product.save!
  end

  def sales_in_range
    return Sale.all if params[:from].nil? || params[:to].nil?

    from = Time.zone.parse(params[:from])
    to = Time.zone.parse(params[:to])

    Sale.all.select { |sale| sale.sale_date >= from && sale.sale_date <= to }
  end

end
