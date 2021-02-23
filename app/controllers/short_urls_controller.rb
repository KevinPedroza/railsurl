class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # We return the top 100
  def index
    render json: { urls: ShortUrl.top_short_url(100) }, status: 200
  end

  # Redirecting to the specified url
  def redirect_url
    if (url = ShortUrl.find_url(params[:id]))
      return redirect_to url
    end

    render json: {
      status: 404, errors: 'Not Found'
    }, status: :not_found
  end

  # Creating the short URL
  def create
    @url = ShortUrl.short_url(params[:full_url])

    if @url.save
      render json: { minified_url: @url }, status: 201
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

end