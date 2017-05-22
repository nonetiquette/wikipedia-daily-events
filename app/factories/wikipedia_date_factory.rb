class WikipediaDateFactory
  attr_accessor :wikipedia_date, :permalink

  def initialize(permalink)
    self.permalink      = WikipediaDateHelper.format_permalink(permalink)
    self.wikipedia_date = ::WikipediaDate.where(permalink: self.permalink).first_or_initialize
  end

  def should_upsert?
    wikipedia_date.new_record?
  end

  def build
    if should_upsert?
      wikipedia_date.occurred_on  = WikipediaDateHelper.convert_permalink_to_date(permalink)
      wikipedia_date.page_url     = "#{::WikipediaDate::BASE_URL}#{permalink}"
      wikipedia_date.save!
    end
    wikipedia_date
  end
end