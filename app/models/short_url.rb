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

  private

    def validate_full_url

    end

end
