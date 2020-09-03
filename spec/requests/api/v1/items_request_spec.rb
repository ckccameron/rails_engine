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

  it "sends item based on unique id" do
    create :merchant
    merchant = Merchant.last
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/#{id}"

    body = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(body[:data][:id]).to eq(id.to_s)
  end
end
