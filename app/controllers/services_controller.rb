class ServicesController < ApplicationController

  # GET /services
  def index
    @services = Service.all

    render json: @services
  end

  # POST /services
  def create
    @service = Service.new(service_params)

    if @service.save
      render json: @service, status: :created, location: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    @service = Service.find(params[:id])
    @service.destroy!
  end

  private

  def service_params
    params.require(:service).permit(:name, :cost, :payment_date)
  end

end
