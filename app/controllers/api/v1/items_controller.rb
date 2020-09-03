class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    id = params[:id]
    render json: ItemSerializer.new(Item.find(id))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params))
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    # render json: ItemSerializer.new(Item.find(params[:id]))
    # Item.delete(params[:id])
    InvoiceItem.where(item_id: params[:id]).delete_all
    Item.delete(params[:id])
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
