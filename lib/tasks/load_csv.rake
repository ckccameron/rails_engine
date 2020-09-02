desc "reset tables and import csv data"
task import: :environment do
  Customer.destroy_all
  Merchant.destroy_all
  Invoice.destroy_all
  Item.destroy_all
  InvoiceItem.destroy_all
  Transaction.destroy_all

  require 'csv'

  CSV.foreach('./db/data/customers.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    Customer.create(row.to_h)
    puts "Customers table csv data setup: Successful"
  end

  CSV.foreach('./db/data/merchants.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    Merchant.create(row.to_h)
    puts "Merchants table csv data setup: Successful"
  end

  CSV.foreach('./db/data/invoices.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    Invoice.create(row.to_h)
    puts "Invoices table csv data setup: Successful"
  end

  CSV.foreach('./db/data/items.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    Item.create(row.to_h)
    puts "Items table csv data setup: Successful"
  end

  CSV.foreach('./db/data/invoice_items.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    InvoiceItem.create(row.to_h)
    puts "Invoice Items table csv data setup: Successful"
  end

  CSV.foreach('./db/data/transactions.csv', headers: true, header_converters: :symbol, converters: :all) do |row|
    Transaction.create(row.to_h)
    puts "Transactions table csv data setup: Successful"
  end

  puts "Database data import: Successful"
end
