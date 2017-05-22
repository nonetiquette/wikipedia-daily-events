module WikipediaDateHelper

  # converts a wikipedia date permalink to a date object
  def self.convert_permalink_to_date(permalink)
    Date.strptime(permalink,"%Y_%B_%e")
  end

  # proper casing and formatting for wikipedia permalinks
  def self.format_permalink(permalink)
    permalink.split('_').map(&:capitalize).join('_')
  end

end
