class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show, :update, :destroy]

  # GET /providers
  def index
    @providers = Provider.all

    render json: @providers
  end

  # GET /providers/1
  def show
    render json: @provider
  end

  # PATCH/PUT /providers/1
  def update
    if @provider.update(provider_params)
      render json: @provider
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /providers/1
  def destroy
    @provider.destroy
  end

  def logs
    logs = Provider.all.map(&:audits).flatten

    render json: {logs: logs}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_provider
    @provider = Provider.find(params[:id])
  end

  def provider_params
    params.require(:provider).permit(:name)
  end
end
