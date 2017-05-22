require 'rubygems'
require 'nokogiri'
require 'open-uri'

class WikipediaEventParserService
  include ActionView::Helpers

  attr_accessor :response_body, :page, :url

  def initialize(url)
    self.url = url
    validate_params
    request_page
  end

  def parse
    self.page = Nokogiri::HTML(self.response_body)
    {
      permalink: parse_permalink,
      page_url: url,
      title: parse_title,
      image_url: parse_image_url,
      summary: parse_summary,
      last_edited_at: parse_last_edited_at
    }
  end

private

  def validate_params
    if !url.include?(::WikipediaEvent::BASE_URL)
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

  def parse_permalink
    url.gsub(::WikipediaEvent::BASE_URL,'')
  end

  def parse_title
    content = page.css('h1#firstHeading').first.try(:content)
    strip_tags(content)
  end

  def parse_image_url
    image_url = page.css('div#bodyContent img').first.try(:[], 'src')
    return nil if !image_url.match(/^\/\/upload.wikimedia.org/).present?
    image_url
  end

  def parse_summary
    content = ''
    page.css('#mw-content-text').children.each do |node|
      if node['class'].present? && node['class'].include?('toc')
        break
      end
      if node.name == 'p' && !node.content.blank?
        content += node.to_html
      end
    end
    strip_tags(content)
  end

  def parse_last_edited_at
    content = page.css('#footer-info-lastmod').first.try(:content)
    return nil if !content.present?
    content = strip_tags(content).strip
    match_data = content.match(/(\d{1,2}\s\w{3,9}\s\d{4}), at (\d{2}:\d{2})/)
    DateTime.strptime("#{match_data[1]} #{match_data[2]}","%e %B %Y %H:%M")
  end
end