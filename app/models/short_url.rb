class ShortUrl < ApplicationRecord
  include ShortUrlsHelper

  # We validate the unique full url and the presence
  validates_presence_of :full_url
  validates_uniqueness_of :full_url, case_sensitive: true

  before_validation :validate_full_url, on: :create

  # We create the URL and minified
  def short_url
    self.minified_url = "#{ENV.fetch('URL_PROTOCOL')}://#{ENV.fetch('URL_HOSTNAME')}/#{ShortUrlsHelper.url_encode(id.to_i)}"

    if save
      update_title(self.id)
      return true
    end

    false
  end

  # We return the top 100
  def self.top_short_url(limit)
    order(click_count: :desc)
      .limit(limit)
      .as_json(except: %i[created_at updated_at])
  end

  # Increment the click_count field by one 
  def increment_click_count
    update(click_count: click_count + 1)
  end

  # We validate the URL
  def validate_full_url
    if self.full_url.nil?
      return
    end

    if((self.full_url =~ URI::regexp("http")) == nil && (self.full_url =~ URI::regexp("https")) == nil)
      self.errors.add(:full_url, "Full url is not a valid url")
    end
  end
  
  # We define the method to return the URL as
  def self.find_url(minified_url)
      id = ShortUrlsHelper.url_decode(minified_url.split("/").last)
      find(id)
    rescue ActiveRecord::RecordNotFound
      false
  end

  # We execute the background job
  def update_title(id)
    UpdateTitleJob.perform_later id
  end

end