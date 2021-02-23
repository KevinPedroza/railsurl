require 'rails_helper'
ENV["URL_PROTOCOL"] = 'http'
ENV["URL_HOSTNAME"] = 'localhost:3000'

RSpec.describe ShortUrlsController, type: :controller do

  let(:parsed_response) { JSON.parse(response.body) }
  let(:public_attributes) do
    {
      "id"            => short_url.id,
      "title"         => short_url.title,
      "full_url"      => short_url.full_url,
      "minified_url"  => short_url.minified_url,
      "click_count"   => short_url.click_count,
    }
  end

  describe "index" do

    let!(:short_url) { ShortUrl.create(full_url: "https://www.test.rspec") }

    it "is a successful response" do
      get :index, format: :json
      expect(response.status).to eq 200
    end

    it "has a list of the top 100 urls" do
      get :index, format: :json

      expect(parsed_response['urls']).to be_include(public_attributes)
    end

  end

  describe "create" do

    it "creates a short_url" do
      post :create, params: { full_url: "https://www.test.rspec" }, format: :json
      expect(parsed_response['minified_url']).to be_a(Object)
    end

    it "does not create a short_url" do
      post :create, params: { full_url: "nope!" }, format: :json
      expect(parsed_response['full_url']).to be_include("Full url is not a valid url")
    end

  end

  describe "redirect" do

    let!(:short_url) { ShortUrl.create(full_url: "https://www.test.rspec") }


    it "redirects to the full_url" do
      short_url.short_url
      get :redirect_url, params: { id: short_url.minified_url }, format: :json
      expect(response).to redirect_to(short_url.full_url)
    end

    it "does not redirect to the full_url" do
      get :redirect_url, params: { id: "nope" }, format: :json
      expect(response.status).to eq(404)
    end

    it "increments the click_count for the url" do
      short_url.short_url
      expect { get :redirect_url, params: { id: short_url.minified_url }, format: :json }.to change { ShortUrl.find(short_url.id).click_count }.by(1)
    end

  end

end
