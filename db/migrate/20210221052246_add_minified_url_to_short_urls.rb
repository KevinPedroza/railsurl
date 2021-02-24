class AddMinifiedUrlToShortUrls < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :minified_url, :string
  end
end
