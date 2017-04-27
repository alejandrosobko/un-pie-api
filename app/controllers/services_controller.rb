class ServicesController < ApplicationController
  before_action :set_service, only: [:update]
  before_action :parse_date, only: [:create]

  # GET /services
  def index
    @services = Service.all

    render json: @services
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
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

  def logs
    logs = Service.all.map(&:audits).flatten

    render json: {logs: logs}
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :cost, :payment_date)
  end

  def parse_date
    date = params[:service][:payment_date] || Time.zone.now.to_s
    params[:service][:payment_date] = Time.zone.parse(date)
  end

end
