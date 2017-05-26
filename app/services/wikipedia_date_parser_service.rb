class WikipediaDateParserService
  attr_accessor :response, :url

  def initialize(url)
    @url = url
    validate_params
    request_page
    evaluate_response
  end
  
  def parse
    page = Nokogiri::HTML(@response.body)
    page.css('table.vevent td.description ul li a:first-child').map do |element|
      "https://en.wikipedia.org#{element['href']}"
    end
  end

private

  def validate_params
    if !@url.include?(::WikipediaDate::BASE_URL)
      raise ::ApiInvalidParametersError.new('URL is not a valid Wikipedia URL.')
    end
  end

  def request_page
    @response = Net::HTTP.get_response(URI.parse(@url))
  end
  
  def evaluate_response
    if @response.is_a?(Net::HTTPNotFound) || @response.is_a?(Net::HTTPMovedPermanently)
      raise ::ExternalPageNotFoundError.new('Wikipedia has no information on that topic.')
    elsif @response.is_a?(Net::HTTPClientError)
      raise ::ExternalPageUnprocessableEntityError.new('Wikipedia didn\'t understand your request.')
    elsif @response.is_a?(Net::HTTPServerError)
      raise ::ExternalPageInternalServerError.new('Wikipedia is having server issues. Please try again at another time.')
    end
  end

end