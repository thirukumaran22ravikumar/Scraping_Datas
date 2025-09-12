class UpdateProductJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find_by(id: product_id)
    return unless product

    scraped = ScraperService.scrape(product.url)
    return unless scraped

    category = Category.find_or_create_by(name: scraped[:category]) if scraped[:category].present?
    product.category = category if category
    product.apply_scrape!(scraped)

    Rails.logger.info "[UpdateProductJob] Successfully updated product #{product.id}"
  rescue => e
    Rails.logger.error "[UpdateProductJob] failed for #{product_id}: #{e.message}"
  end
end
