require "rails_helper"

RSpec.describe Product, type: :model do
  it "is valid with valid attributes" do
    category = Category.create!(name: "Sunglasses")
    product = Product.new(
      title: "Test Product",
      price: "₹199",
      url: "https://example.com/product123",
      category: category
    )
    expect(product).to be_valid
  end

  it "is invalid without a title" do
    product = Product.new(price: "₹199", url: "https://example.com")
    expect(product).not_to be_valid
  end
end
