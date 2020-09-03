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
end
