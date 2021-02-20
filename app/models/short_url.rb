class ShortUrl < ApplicationRecord

  validate_presence_of: :full_url

  # The scope to get the top of the short url
  scope :top_short_url, -> (top_limit) { order('click_count desc').limit(top_limit) }

  before_validation :validate_full_url, on: :create

  def short_url(full_url)
    url = ShortUrl.create(full_url: full_url)
    url.minified_url = "#{ENV.fetch('URL_PROTOCOL')}://#{ENV.fetch('URL_HOSTNAME')}/s/#{MinifyUrlService.instance.url_encode(url.id)}"
    url.click_count = u.click_count + 1
    url.save!
    url
  end

  # We validate the URL
  def validate_full_url
    url = URI.parse(self.full_url)

    if(!url.scheme)
      self.url = "http://#{self.full_url}"
    end
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
      url.save!
      url
    end
  end

end
