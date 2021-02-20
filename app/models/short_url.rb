class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate_presence_of: :url, :access

  before_validation :validate_full_url, on: :create

  # The scope to get the top of the short url
  scope :top_short_url, -> (top_limit) { order('access desc').limit(top_limit) }

  def short_url(url)

  end

  def update_title!
  end

  def validate_full_url
    url = URI.parse(self.url)

    if(!url.scheme)
      self.url = "http://#{self.url}"
    end
  end

  private

    def self.increase_access_url(minified_url)
      url = where(minified_url: minified_url)

      if (url.any?)
        url = url.first
        url.access += 1
        url.save!
        url
      end
    end

end
