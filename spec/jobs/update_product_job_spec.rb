require 'rails_helper'

RSpec.describe UpdateProductJob, type: :job do
  let!(:category) { Category.create!(name: "Test Category") }
  let!(:product) { Product.create!(url: "https://example.com", title: "Old Title", category: category) }

  it "updates a product when scrape succeeds" do
    allow(ScraperService).to receive(:scrape).and_return({ title: "New Title" })

    expect {
      UpdateProductJob.perform_now(product.id)
    }.to change { product.reload.title }.from("Old Title").to("New Title")
  end

  it "does nothing if scrape returns nil" do
    allow(ScraperService).to receive(:scrape).and_return(nil)

    expect {
      UpdateProductJob.perform_now(product.id)
    }.not_to change { product.reload.updated_at }
  end
end
