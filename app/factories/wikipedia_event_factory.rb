class WikipediaEventFactory
  attr_accessor :wikipedia_date_event, :attributes

  def initialize(wikipedia_date_id, permalink, attributes = {})
    self.attributes = attributes
    self.wikipedia_date_event = ::WikipediaEvent.where(wikipedia_date_id: wikipedia_date_id, permalink: permalink).first_or_initialize
  end

  # upsert if it's either a new record or it has been edited recently
  def should_upsert?
    wikipedia_date_event.new_record? ||
      (!attributes.empty? && attributes[:last_edited_at].present? && wikipedia_date_event.last_edited_at.present? &&
        attributes[:last_edited_at] > wikipedia_date_event.last_edited_at)
  end

  def build
    if should_upsert?
      wikipedia_date_event.update_attributes(attributes)
    end
    wikipedia_date_event
  end
end