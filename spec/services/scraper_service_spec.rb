require "rails_helper"

RSpec.describe ScraperService do
  it "scrapes real product data" do
    result = ScraperService.scrape("https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06")
    expect(result[:title]).to be_present
    expect(result[:price]).to be_present
  end
end
