class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_by_search_criteria(fragment)
    Merchant.where("name ILIKE ?", "%#{fragment}%")
  end

end
