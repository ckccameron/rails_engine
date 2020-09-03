require 'rails_helper'

describe "Items API" do
  it "sends index of items" do
    create :merchant
    merchant = Merchant.last

    3.times do
      create(:item, merchant: merchant)
    end

    get "/api/v1/items"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)
    expect(body[:data].count).to eq(3)
    expect(body[:data]).to_not be_empty
  end
end
