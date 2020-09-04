class Api::V1::Merchants::ItemsSoldController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.most_items_sold(params[:quantity]))
  end
end
