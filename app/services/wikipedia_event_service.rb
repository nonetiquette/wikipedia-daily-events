class WikipediaEventService
  attr_accessor :wikipedia_date_id, :permalink, :attributes

  def initialize(wikipedia_date_id, permalink, attributes = {})
    @wikipedia_date_id = wikipedia_date_id
    @permalink = permalink
    @attributes = attributes.merge({permalink: permalink})
  end

  def find_or_create
    wikipedia_event = ::WikipediaEvent.where(wikipedia_date_id: @wikipedia_date_id, permalink: @permalink).first_or_initialize
    if wikipedia_event.new_record?
      wikipedia_event.update_attributes(@attributes)
    end
    wikipedia_event
  end
end