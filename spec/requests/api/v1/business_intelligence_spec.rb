require 'rails_helper'

describe "Business Intel API" do
  before :each do
    merchant_1 = Merchant.create!(name: "Top Sellers")
    merchant_2 = Merchant.create!(name: "Next Best Top Sellers")
    merchant_3 = Merchant.create!(name: "Third Best Top Sellers")
    create_list(:merchant, 7)
    @id = merchant_3.id

    customer_1 = Customer.create!(first_name: "Shaquille", last_name: "O'Neal")
    customer_2 = Customer.create!(first_name: "Bill", last_name: "Russell")
    customer_3 = Customer.create!(first_name: "Wilt", last_name: "Chamberlain")

    item_1 = create(:item, merchant: merchant_1, unit_price: 100)
    item_2 = create(:item, merchant: merchant_2, unit_price: 50)
    item_3 = create(:item, merchant: merchant_3, unit_price: 20)

    invoice_1 = merchant_1.invoices.create!(customer: customer_1, status: "shipped")
    invoice_2 = merchant_2.invoices.create!(customer: customer_2, status: "shipped")
    invoice_3 = merchant_3.invoices.create!(customer: customer_3, status: "shipped")

    invoice_1.invoice_items.create!(item: item_1, quantity: 3, unit_price: 100)
    invoice_2.invoice_items.create!(item: item_2, quantity: 5, unit_price: 50)
    invoice_3.invoice_items.create!(item: item_3, quantity: 3, unit_price: 20)

    invoice_1.transactions.create!(result: 'success')
    invoice_2.transactions.create!(result: 'success')
    invoice_3.transactions.create!(result: 'success')
  end

  it "returns list of merchants determined by most revenue" do
    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    results = JSON.parse(response.body, symbolize_names: true)

    expect(results[:data].length).to eq(2)
    expect(results[:data].first[:attributes][:name]).to eq("Top Sellers")
    expect(results[:data].last[:attributes][:name]).to eq("Next Best Top Sellers")
  end
end
