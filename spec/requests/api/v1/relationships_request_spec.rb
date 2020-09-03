require 'rails_helper'

describe "Relationships API" do
  it "sends list of items associated with a merchant" do
    create_list(:merchant, 3)
    id_1 = Merchant.first.id
    id_2 = Merchant.last.id

    create(:item, merchant_id: id_1)
    create(:item, merchant_id: id_1)
    create(:item, merchant_id: id_1)
    first_item = Item.first

    create(:item, merchant_id: id_2)
    last_item = Item.last

    get "/api/v1/merchants/#{id_1}/items"

    expect(response).to be_successful
    id_1_items = JSON.parse(response.body, symbolize_names: true)

    expect(id_1_items[:data].count).to eq(3)
    expect(id_1_items[:data].first[:id]).to eq(first_item.id.to_s)
    expect(id_1_items[:data].last[:id]).to_not eq(last_item.id.to_s)

    get "/api/v1/merchants/#{id_2}/items"

    expect(response).to be_successful
    id_2_items = JSON.parse(response.body, symbolize_names: true)
    expect(id_2_items[:data].count).to eq(1)
    expect(id_2_items[:data].first[:id]).to eq(last_item.id.to_s)
  end
end
