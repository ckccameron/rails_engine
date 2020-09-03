class Api::V1::Items::FinderController < ApplicationController
  def index
    items = Item.find_by_search_criteria(params[:name])
    render json: ItemSerializer.new(items).serialized_json
  end
end
