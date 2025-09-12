require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  describe "GET /api/v1/products" do
    it "returns a list of products" do
      category = Category.create!(name: "Test Category")
      Product.create!(url: "https://example.com", title: "Test Product", category: category)
      
      get "/api/v1/products"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Test Product")
    end
  end
end
