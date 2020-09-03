class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    id = params[:id]
    render json: MerchantSerializer.new(Merchant.find(id))
  end

  def create
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy
    # render json: MerchantSerializer.new(Merchant.find(params[:id]))
    # Merchant.delete(params[:id])
    Invoice.where(merchant_id: params[:id]).each do |invoice|
      InvoiceItem.where(invoice_id: invoice.id).delete_all
      Transaction.where(invoice_id: invoice.id).delete_all
      invoice.destroy
    end

    Item.where(merchant_id: params[:id]).delete_all
    Merchant.delete(params[:id])
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
