require 'rails_helper'

describe "Items API finders" do
  it "can return a single item that matches search criteria" do

  end

  it "can return index of items that match search criteria" do
    merchant = create(:merchant)
    item = create(:item, name: "Denver Nuggets jersey", merchant: merchant)
    item_2 = create(:item, name: "Denver Broncos jersey", merchant: merchant)
    item_3 = create(:item, name: "San Andreas Aces jersey", merchant: merchant)

    get "/api/v1/items/find_all?name=Denver"

    expect(response).to be_successful

    search_body = JSON.parse(response.body, symbolize_names: true)
    names = search_body[:data].map do |merchant|
      merchant[:attributes][:name]
    end

    expect(search_body[:data]).to be_a(Array)
    expect(names).to include("Denver")
    expect(names).to eq(["Denver Nuggets jersey", "Denver Broncos jersey"])
    expect(names).to_not eq(["San Andreas Aces jersey"])
  end
end
