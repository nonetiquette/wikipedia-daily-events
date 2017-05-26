module WikipediaDateHelper

  # converts a wikipedia date permalink to a date object
  def self.convert_permalink_to_date(permalink)
    Date.strptime(permalink.gsub(/\s+/, ''), WikipediaDate::PERMALINK_DATE_FORMAT)
  end

  # proper casing and formatting for wikipedia date permalinks
  def self.normalize_permalink(permalink)
    permalink.gsub(/\s+/, '').split('_').map(&:capitalize).join('_')
  end

end
