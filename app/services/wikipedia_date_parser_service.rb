require 'rubygems'
require 'nokogiri'
require 'open-uri'

class WikipediaDateParserService
  attr_accessor :response_body, :url

  def initialize(url)
    self.url = url
    validate_params
    request_page
  end
  
  def parse
    page = Nokogiri::HTML(self.response_body)
    page.css('table.vevent td.description ul li a:first-child').map do |element|
      "https://en.wikipedia.org#{element['href']}"
    end
  end

private

  def validate_params
    if !url.include?(::WikipediaDate::BASE_URL)
      raise ::ApiInvalidParametersError.new('URL is not a valid Wikipedia URL.')
    end
  end

  def request_page
    response = Net::HTTP.get_response(URI.parse(url))
    if response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
      self.response_body = response.body
    elsif response.is_a?(Net::HTTPNotFound)
      raise ::ExternalPageNotFoundError.new('Wikipedia has no information on that topic.')
    elsif response.is_a?(Net::HTTPClientError)
      raise ::ExternalPageUnprocessableEntityError.new('Wikipedia didn\'t understand your request.')
    else
      raise ::ExternalPageInternalServerError.new('Wikipedia is having server issues. Please try again at another time.')
    end
  end

end