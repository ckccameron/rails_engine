class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.most_revenue(params[:quantity]))
  end

  def show
    value = Merchant.revenue(params[:id])
    render json: RevenueSerializer.new(Revenue.new(value))
  end
end
