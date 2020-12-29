class Member < ApplicationRecord
  has_many :headings
  has_many :friendships

  validates :name, :website_url, presence: true

  before_commit :shorten_url
  after_commit :create_headings, on: :create

  def shorten_url
    # This is fast enough to just stay here, but could be a background job / service if needed
    client = Bitly::API::Client.new(token: Rails.application.credentials.bitly[:access_token])

    shortened_link = client.shorten(long_url: self.website_url)
    self.shortened_url = shortened_link.link
    self.save
  end

  def create_headings
    # TODO: Handle exceptions
    # This can be extracted to a background job / service if there's time
    site = Nokogiri::HTML(URI.open(self.website_url))
    ['h1','h2','h3'].each do |tag|
      site.css(tag).each do |i|
        Heading.create(member_id: self.id, content: i.text.strip)
      end
    end
  end
end
