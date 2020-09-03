class Api::V1::Merchants::FinderController < ApplicationController

  def show
    merchants = Merchant.find_by_search_criteria(params[:name]).first
    render json: MerchantSerializer.new(merchants).serialized_json
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end
end
