# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

=begin
676.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    price: Faker::Commerce.price,
    stock_quantity: Faker::Number.number
  )
end
puts "Created 676 products successfully."
=end

require "csv"

Product.destroy_all

Category.destroy_all

# Set the path to the CSV file and read CSV data
csv_file = Rails.root.join('db/products.csv')
csv_data = File.read(csv_file)

# Parse the CSV data with headers in windows
products = CSV.parse(csv_data, headers: true, encoding: 'utf-8')

products.each do |row|
  category_name = row['category']

  # Find the category by name,if it doesn't exist, create it
  category = Category.find_or_create_by!(name: category_name)

  # Now create a product associated with this category
  Product.create!(
    title: row['name'],
    price: row['price'].to_d,
    description: row['description'],
    stock_quantity: row['stock quantity'].to_i,
    category: category  #foreign key
  )
end

puts "Imported #{products.size} products"
