class Api::V1::ProductsController < ApplicationController

  # def create
  #   data = ScraperService.scrape(params[:url])
  #   return render json: { error: 'Failed to scrape' }, status: 422 unless data

  #   category = Category.find_or_create_by(name: data[:category])
  #   product = category.products.create(
  #     title: data[:title],
  #     price: data[:price],
  #     description: data[:description],
  #     url: params[:url],
  #     scraped_at: Time.current
  #   )

  #   # render json: product
  #   render json: [product], status: :ok 
  # end


  def create
    scraped_data = ScraperService.scrape(params[:url])
    return render json: { error: "Scraping failed" }, status: :unprocessable_entity if scraped_data.nil?
    category = Category.find_or_create_by!(name: params[:category_name] || scraped_data[:category])
    product = Product.create!(
      title: scraped_data[:title],
      description: scraped_data[:description],
      price: scraped_data[:price],
      url: params[:url],
      category: category,
      scraped_at: Time.current
    )
    render json: product, status: :ok
  end


    def index
      puts "-----------------------comming inside index---------------------"
      products = Product.includes(:category).order(created_at: :desc)
      p params[:query].to_s
      if params[:query].present?
        q = "%#{params[:query]}%"
        products = products.where("title LIKE ? OR description LIKE ?", q, q)
      end

      if params[:category].present?
        products = products.joins(:category).where(categories: { name: params[:category] })
      end

  
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 20).to_i
      paginated = products.respond_to?(:page) ? products.page(page).per(per_page) : products.slice((page-1)*per_page, per_page) || []

      render json: paginated.as_json(include: { category: { only: [:id, :name] } })
    end


    def refetch
      p "-----------------------comming inside refetch---------------------"
      product = Product.find_by(id: params[:id])
      return render json: { error: "not found" }, status: :not_found unless product

      UpdateProductJob.perform_later(product.id)
      render json: { job: "scheduled" }, status: :ok
    end

end
