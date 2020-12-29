class Member < ApplicationRecord
  has_many :headings

  before_commit :shorten_url
  after_commit :create_headings, on: :create

  def shorten_url
    client = Bitly::API::Client.new(token: Rails.application.credentials.bitly[:access_token])

    shortened_link = client.shorten(long_url: self.website_url)
    self.shortened_url = shortened_link.link
    self.save
  end

  def create_headings
    site = Nokogiri::HTML(URI.open(self.website_url))
    ['h1','h2','h3'].each do |tag|
      site.css(tag).each do |i|
        Heading.create(member_id: self.id, content: i.text.strip)
      end
    end
  end
end
