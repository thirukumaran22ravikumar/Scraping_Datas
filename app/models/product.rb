class Product < ApplicationRecord
    belongs_to :category
    validates :title, :url, presence: true

    def stale?
        scraped_at.nil? || scraped_at < 1.week.ago
    end

  # Update attributes from scraped hash and touch scraped_at
  def apply_scrape!(data)
    assign_attributes(
      title: data[:title] || title,
      description: data[:description] || description,
      price: data[:price] || price,
      contact: data[:contact] || contact,
      size: data[:size] || size
    )
    self.scraped_at = Time.current
    save!
  end
  
end
