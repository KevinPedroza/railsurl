class UpdateTitleJob < ApplicationJob
  require 'open-uri'

  include ActiveRecord
  include HTTParty

  queue_as :default

  def perform(short_url_id)
      url = ShortUrl.find(short_url_id)

      response = HTTParty.get(url.full_url)
      html = Nokogiri::HTML.parse(response.body)

      url.update(title: html.title)

    rescue ActiveRecord::RecordNotFound => e
      puts e
  end
end
