class Api::V1::Items::MerchantsController < ApplicationController
  def show
    render json: MerchantSerializer.new(Item.find_by(id: params["item_id"]).merchant)
  end
end
