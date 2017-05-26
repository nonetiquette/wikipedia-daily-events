class WikipediaDateService
  attr_accessor :permalink

  def initialize(permalink)
    @permalink      = permalink
  end

  def find_or_create
    wikipedia_date = ::WikipediaDate.where(permalink: @permalink).first_or_initialize
    if wikipedia_date.new_record?
      wikipedia_date.permalink    = WikipediaDateHelper.normalize_permalink(@permalink)
      wikipedia_date.occurred_on  = WikipediaDateHelper.convert_permalink_to_date(@permalink)
      wikipedia_date.page_url     = "#{::WikipediaDate::BASE_URL}#{@permalink}"
      wikipedia_date.save!
    end
    wikipedia_date
  end
end