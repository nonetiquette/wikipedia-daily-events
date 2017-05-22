# == Schema Information
#
# Table name: wikipedia_dates
#
#  id          :integer          not null, primary key
#  permalink   :string
#  page_url    :string
#  occurred_on :date
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_wikipedia_dates_on_occurred_on  (occurred_on)
#  index_wikipedia_dates_on_permalink    (permalink)
#

class WikipediaDateSerializer < ActiveModel::Serializer
  attributes :id, :permalink, :page_url, :occurred_on
end
