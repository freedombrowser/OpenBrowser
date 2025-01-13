class Api::V1::SitemapsController < ApplicationController
  # GET /api/v1/sitemaps
  def index
    # Fetch all records from the sitemap table
    sitemaps = Sitemap.all

    # Return the data as JSON
    render json: sitemaps
  end

  # GET /api/v1/sitemaps/:name/url
  def show_url_by_name
    sitemap = Sitemap.find_by(name: params[:name])

    if sitemap
      render json: { url: sitemap.url }
    else
      render json: { error: 'Page not found' }, status: :not_found
    end
  end
end
