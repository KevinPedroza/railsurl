class ShortUrl < ApplicationRecord

  # We validate the unique full url and the presence
  validates_presence_of :full_url, on: :create
  validates_uniqueness_of :full_url, case_sensitive: true

  # The scope to get the top of the short url
  scope :top_short_url, -> (top_limit) { order('click_count desc').limit(top_limit) }

  before_validation :validate_full_url, on: :create

  # We create the URL and minified
  def self.short_url(full_url)
    url = ShortUrl.create(full_url: full_url)

    if url.valid?
      url.minified_url = "#{ENV.fetch('URL_PROTOCOL')}://#{ENV.fetch('URL_HOSTNAME')}/s/#{MinifyUrlService.instance.url_encode(url.id)}"
      url.click_count = url.click_count + 1
      url.save
    end

    url
  end

  # We validate the URL
  def validate_full_url
    url = URI.parse(self.full_url)

    if(!url.scheme)
      self.errors.add(:full_url, "Invalid URL")
      false
    end
  end

  # We decode the short code from the URL
  def self.decode_url(minified_url)
    MinifyUrlService.instance.url_decode(minified_url.split('/').last)
  end

  # We search for the URL
  def self.find_url(url)
  end

  # We increase the access of the URL
  def self.increase_click_count_url(minified_url)
    url = where(minified_url: minified_url)

    if (url.any?)
      url = url.first
      url.click_count += 1
      url.save
      url
    end
  end

end
