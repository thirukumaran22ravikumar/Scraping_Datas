# require 'net/http'
# require 'nokogiri'
# require 'uri'

# class ScraperService
#   def self.scrape(url)
#     uri = URI.parse(url)
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = (uri.scheme == "https")

#     request = Net::HTTP::Get.new(uri.request_uri)
#     request['User-Agent'] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115 Safari/537.36"
#     request['Accept-Language'] = "en-US,en;q=0.9"

#     response = http.request(request)

#     if response.code.to_i >= 400
#       Rails.logger.error "HTTP #{response.code} - Request blocked"
#       return nil
#     end

#     doc = Nokogiri::HTML(response.body)

#     {
#       title: doc.at_css('span.B_NuCI')&.text,
#       price: doc.at_css('div._30jeq3')&.text,
#       description: doc.at_css('div._1mXcCf')&.text,
#       category: doc.at_css('a._1QZ6fC')&.text
#     }
#   rescue => e
#     Rails.logger.error "Scraping failed: #{e.message}"
#     nil
#   end
# end



# require 'playwright'

# class ScraperService
#   def self.scrape(url)
#     cli_path = Rails.root.join('node_modules', '.bin', 'playwright').to_s

#     Playwright.create(playwright_cli_executable_path: cli_path) do |playwright|
#       browser = playwright.chromium.launch(headless: false)
#       page = browser.new_page

#       page.set_extra_http_headers({
#         'User-Agent' => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115 Safari/537.36"
#       })

#       Rails.logger.info "[Scraper] Opening page..."
#       page.goto(url, wait_until: 'networkidle', timeout: 30_000)

#       # Wait a bit to ensure JS has rendered the page
#       sleep 2

#       # Use substring match selectors to avoid brittle classes
#       title = page.query_selector("span[class*='B_NuCI'], span[class*='_35KyD6']")&.inner_text
#       price = page.query_selector("div[class*='_30jeq3']")&.inner_text
#       description = page.query_selector("div[class*='_1mXcCf'], div[class*='q6DClP']")&.inner_text
#       category = page.query_selector("a[class*='_1QZ6fC']")&.inner_text

#       Rails.logger.info "[Scraper] Found title: #{title}, price: #{price}"

#       browser.close

#       return nil unless title && price

#       {
#         title: title.strip,
#         price: price.strip,
#         description: description&.strip,
#         category: category&.strip
#       }
#     end
#   rescue => e
#     Rails.logger.error "Playwright scraping failed: #{e.message}"
#     nil
#   end
# end
require 'playwright'

class ScraperService
  def self.scrape(url)
    cli_path = Rails.root.join('node_modules', '.bin', 'playwright').to_s

    Playwright.create(playwright_cli_executable_path: cli_path) do |playwright|
      browser = playwright.chromium.launch(headless: false)
      page = browser.new_page

      page.set_extra_http_headers({
        'User-Agent' => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115 Safari/537.36"
      })

      Rails.logger.info "[Scraper] Opening page..."
      page.goto(url, timeout: 60_000)
      # page.goto(url, wait_until: 'networkidle', timeout: 60000)

      sleep 3  

      
      page.wait_for_selector("h1 span", timeout: 40_000)

      # Extract data
      title = page.query_selector("h1 span")&.inner_text
      description = page.query_selector("h1 span.VU-ZEz")&.inner_text
      price = page.query_selector("div.Nx9bqj.CxhGGd")&.inner_text
      original_price = page.query_selector("div.yRaY8j.A6+E6v")&.inner_text
      discount = page.query_selector("div.UkUFwK span")&.inner_text
      rating = page.query_selector("span.Y1HWO0")&.inner_text
      reviews = page.query_selector("span.Wphh3N")&.inner_text
      extra_offer = page.query_selector("div._2lX4N0 span")&.inner_text
      # category = page.query_selector("div.r2CdBx a.R0cyWM")&.inner_text 

      browser.close

      return nil unless title && price

      ddd ={
        title: title.strip,
        price: price.strip,
        original_price: original_price&.strip,
        discount: discount&.strip,
        rating: rating&.strip,
        reviews: reviews&.strip,
        extra_offer: extra_offer&.strip,
        description: description&.strip,
        # category: category&.strip
      }
      p ddd
    end
  rescue => e
    Rails.logger.error "Playwright scraping failed: #{e.message}"
    nil
  end
end
