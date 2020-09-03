require 'rails_helper'

describe "Merchants API" do
  it "sends index of merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)
    expect(body[:data].count).to eq(3)
  end

  it "sends merchant based on unique id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    body = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(body[:data][:id]).to eq(id.to_s)
  end

  it "allows for a new merchant to be created" do
    post "/api/v1/merchants", params: {name: "ABCMerchant123"}

    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq("ABCMerchant123")
    expect(merchant.name).to_not eq(nil)
  end

  it "allows for a merchant to be updated" do
    id = create(:merchant).id
    old_name = Merchant.last.name

    patch "/api/v1/merchants/#{id}", params: {name: "NewMerchant, NewName"}

    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to eq("NewMerchant, NewName")
    expect(merchant.name).to_not eq(old_name)
  end

  it "can destroy a merchant" do
    id_1 = create(:merchant).id
    id_2 = create(:merchant).id

    delete "/api/v1/merchants/#{id_1}"

    expect(Merchant.count).to eq(1)
    expect{Item.find(id_1)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "finders" do
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

    it "can return index of merchants that match search criteria" do
      create(:merchant, name: "King of Wakanda")
      create(:merchant, name: "Burger King")
      create(:merchant, name: "Kings & Queens")
      create(:merchant, name: "Ace of Spades")

      get "/api/v1/merchants/find?name=king"

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
end
