class ShortUrl < ApplicationRecord

  # We validate the unique full url and the presence
  validates_presence_of :full_url
  validates_uniqueness_of :full_url, case_sensitive: true

  # The scope to get the top of the short url
  scope :top_short_url, -> (top_limit) { order('click_count desc').limit(top_limit) }

  before_validation :validate_full_url, on: :create

  # We create the URL and minified
  def self.short_url(full_url)
    @url = ShortUrl.create(full_url: full_url)

    if @url.valid?
      # We call the background job to update the title
      update_title(@url.id)
      
      @url.minified_url = "#{ENV.fetch('URL_PROTOCOL')}://#{ENV.fetch('URL_HOSTNAME')}/s/#{MinifyUrlService.instance.url_encode(@url.id)}"
      @url.save
    end

    @url
  end

  # We validate the URL
  def validate_full_url
    if self.full_url.nil?
      return
    end

    if((self.full_url =~ URI::regexp("http")) == nil || (self.full_url =~ URI::regexp("http")) == nil)
      self.errors.add(:full_url, "Full url is not a valid url")
    end
  end

  # We decode the short code from the URL
  def self.decode_url(minified_url)
    MinifyUrlService.instance.url_decode(minified_url.split('/').last)
  end
  
  # We define the method to return the URL as
  def self.find_url(minified_url)
    result_url = ''

    result = ShortUrl.find(decode_url(minified_url))
    if result.present?
      url = result
      result.click_count += 1
      result.save
      result_url = result.full_url
    else
      false
    end

    result_url
  end

  # We execute the background job
  def self.update_title(id)
    UpdateTitleJob.perform_later id
  end

end
