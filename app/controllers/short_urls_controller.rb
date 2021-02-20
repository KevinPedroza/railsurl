class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Returning the 100 top urls
  def top_url
    render json: ShortUrl.top_short_url(100), status: 200
  end

  # Return an specific shor url
  def find_shor_url
    url = Url.lookup(params[:id])
    render json: {short_url: url}, status: 200
  end

  # Redirecting to the specified url
  def redirect_url
    url = ShortUrl.lookup(params[:id])
    redirect_to url
  end

  # Creating the short URL
  def create

  end

end