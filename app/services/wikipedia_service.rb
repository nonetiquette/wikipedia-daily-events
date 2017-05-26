class WikipediaService
  attr_accessor :wikipedia_date, :wikipedia_events, :permalink

  def initialize(permalink)
    @permalink = permalink
    @wikipedia_date
    @wikipedia_events = []
  end

  def find_or_create
    WikipediaDate.transaction do
      @wikipedia_date = ::WikipediaDateService.new(permalink).find_or_create
      if wikipedia_date.events.present?
        @wikipedia_events = wikipedia_date.events
      else
        wikipedia_event_urls = ::WikipediaDateParserService.new(wikipedia_date.page_url).parse
        @wikipedia_events = find_or_create_wikipedia_events(wikipedia_date.id, wikipedia_event_urls)
      end
    end
  end

  private

  def find_or_create_wikipedia_events(wikipedia_date_id, event_urls)
    event_urls.each do |url|
      begin
        attributes = ::WikipediaEventParserService.new(url).parse
        ::WikipediaEventService.new(wikipedia_date_id, attributes[:permalink], attributes).find_or_create
      rescue
        next
      end
    end
    wikipedia_date.reload.events
  end

end