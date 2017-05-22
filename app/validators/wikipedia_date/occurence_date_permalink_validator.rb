class WikipediaDate::OccurenceDatePermalinkValidator
  include ActiveModel::Validations

  attr_accessor :occurrence_date_permalink

  validates :occurrence_date_permalink, presence: true, format: { with: /\A\d{4}_\w{3,9}_\d{1,2}\z/ }

  def initialize(occurrence_date_permalink)
    self.occurrence_date_permalink  = occurrence_date_permalink
  end
end