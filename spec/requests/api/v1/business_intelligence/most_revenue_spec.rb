require 'rails_helper'

describe "Business Intel API" do
  it "returns merchant with most revenue" do
    customer1 = create(:customer)
    customer2 = create(:customer)

    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)

    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)
    item3 = create(:item, merchant: merchant3)

    invoice1 = Invoice.create!(customer: customer1, merchant: merchant1, status: "shipped")
    invoice2 = Invoice.create!(customer: customer2, merchant: merchant2, status: "shipped")
    invoice3 = Invoice.create!(customer: customer1, merchant: merchant3, status: "shipped")
    invoice4 = Invoice.create!(customer: customer2, merchant: merchant3, status: "shipped")

    item_invoice1 = InvoiceItem.create!(item: item1, invoice: invoice1, quantity: 1, unit_price: item1.unit_price)
    item_invoice2 = InvoiceItem.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
    item_invoice3 = InvoiceItem.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
    item_invoice4 = InvoiceItem.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
    item_invoice5 = InvoiceItem.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
    item_invoice6 = InvoiceItem.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
    item_invoice7 = InvoiceItem.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)

    transaction1 = Transaction.create!(invoice: invoice1, credit_card_number: '111111111', credit_card_expiration_date: nil, result: "success")
    transaction2 = Transaction.create!(invoice: invoice2, credit_card_number: '222222222', credit_card_expiration_date: nil, result: "success")
    transaction3 = Transaction.create!(invoice: invoice3, credit_card_number: '111111111', credit_card_expiration_date: nil, result: "success")
    transaction4 = Transaction.create!(invoice: invoice4, credit_card_number: '222222222', credit_card_expiration_date: nil, result: "success")

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")

    results = JSON.parse(response.body, symbolize_names: true)

    expect(results[:data].size).to eq(2)
    expect(results[:data][0][:id]).to include(merchant3.id.to_s)
    expect(results[:data][1][:id]).to include(merchant2.id.to_s)
    expect(results[:data]).to_not include(merchant1.id.to_s)
  end
end
