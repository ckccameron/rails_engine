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

  it "allows for a new item to be created" do
    create :merchant
    merchant = Merchant.last
    body = {
          name: "NewItem",
          description: "words with some more words",
          unit_price: 1000,
          merchant_id: merchant.id
        }

    post "/api/v1/items", params: body

    new_item = Item.last

    expect(response).to be_successful
    expect(new_item.name).to eq("NewItem")
    expect(new_item.description).to eq("words with some more words")
  end

  it "allows for an item to be updated" do
    merchant = create :merchant
    id = create(:item, merchant: merchant).id
    old_name = Item.last.name

    patch "/api/v1/items/#{id}", params: {name: "NewItem, NewName"}

    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to eq("NewItem, NewName")
    expect(item.name).to_not eq(old_name)
  end

  it "can destroy an item" do
    merchant = create :merchant
    id = create(:item, merchant: merchant).id
    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
