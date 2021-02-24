class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # We return the top 100
  def index
    render json: { status: 200, urls: ShortUrl.top_short_url(100) }
  end

  # Redirecting to the specified url
  def redirect_url
    if (url = ShortUrl.find_url(params[:id]))
      url.increment_click_count
      return redirect_to url.full_url
    end

    render json: {
      status: 404, errors: 'Not Found'
    }, status: :not_found
  end

  # Creating the short URL
  def create
    url = ShortUrl.create(params_url)

    if url.short_url
      render json: { status: 201, minified_url: url.minified_url }
    else
      render json: url.errors, status: :unprocessable_entity
    end
  end

  private
    def params_url
      params.permit(:full_url)
    end
end