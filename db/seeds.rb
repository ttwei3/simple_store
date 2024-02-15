# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "csv"

=begin
676.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    price: Faker::Commerce.price,
    stock_quantity: Faker::Number.number
  )
end
=end

Product.destroy_all

Category.destroy_all

csv_file = Rails.root.join('db/products.csv')
csv_data = File.read(csv_file)

products = CSV.parse(csv_data, headers: true)

# If CSV was created by Excel in Windows you may also need to set an encoding type:
# products = CSV.parse(csv_data, headers: true, encoding: 'iso-8859-1')

products.each do |product|
  category_name = product[:category]
  category_name = category_name.split(',').first if category_name&.include?(',')
  category = Category.find_or_create_by(name: category_name) if category_name

  Product.create(
    title: product[:name],
    description: product[:description],
    price: product[:price],
    stock_quantity: product[:stock_quantity],
    category: category
  )
end

# Where "category_name" is the category name as a string. You will need to get this from the data returned from the csv library.