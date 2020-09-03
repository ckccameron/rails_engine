require 'rails_helper'

describe "Merchants API finders" do
  it "can return a single merchant that matches search criteria" do
    create(:merchant, name: "In N Out")
    create(:merchant, name: "Chipotle")
    create(:merchant, name: "Sabor")

    get "/api/v1/merchants/find?name=in"

    expect(response).to be_successful

    search_body = JSON.parse(response.body, symbolize_names: true)
    name = search_body[:data][:attributes][:name].downcase

    expect(search_body[:data]).to be_a(Hash)
    expect(name).to include("in")
  end

  xit "can return index of merchants that match search criteria" do
    create(:merchant, name: "King of Wakanda")
    create(:merchant, name: "Burger King")
    create(:merchant, name: "Kings & Queens")
    create(:merchant, name: "Ace of Spades")

    get "/api/v1/merchants/find_all?name=king"

    expect(response).to be_successful

    search_body = JSON.parse(response.body, symbolize_names: true)
    names = search_body[:data].map do |merchant|
      merchant[:attributes][:name].downcase
    end

    expect(search_body[:data]).to be_a(Hash)
    expect(names).to include("king")
    expect(names).to eq(["King of Wakanda", "Burger King", "Kings & Queens"])
    expect(names).to_not eq(["Ace of Spades"])
  end
end
