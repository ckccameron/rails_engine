class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices

  def self.find_by_search_criteria(fragment)
    Merchant.where("name ILIKE ?", "%#{fragment}%")
  end

  def self.most_revenue(param)
    Merchant.select("merchants.*, sum(quantity * unit_price) as revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .where("invoices.status = 'shipped'")
    .group(:id)
    .order("revenue desc")
    .limit(param)
  end

  def self.most_items_sold(param)
    Merchant.select("merchants.*, sum(quantity) as items_sold")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("items_sold desc")
    .limit(param)
  end

  def self.revenue(merchant_id)
    joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .where(id: merchant_id)
    .sum("quantity * unit_price")
  end
end
