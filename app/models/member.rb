class Member < ApplicationRecord

  after_commit :shorten_url, on: :create

  def shorten_url
    client = Bitly::API::Client.new(token: Rails.application.credentials.bitly[:access_token])

    shortened_link = client.shorten(long_url: self.website_url)
    self.shortened_url = shortened_link.link
    self.save
  end
end
