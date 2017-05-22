# == Schema Information
#
# Table name: wikipedia_events
#
#  id                :integer          not null, primary key
#  wikipedia_date_id :integer
#  permalink         :string
#  page_url          :string
#  title             :string
#  summary           :text
#  image_url         :string
#  last_edited_at    :datetime
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_wikipedia_events_on_permalink          (permalink)
#  index_wikipedia_events_on_wikipedia_date_id  (wikipedia_date_id)
#

class WikipediaEventSerializer < ActiveModel::Serializer
  attributes :id, :wikipedia_date_id, :permalink, :page_url, :title, :summary, :image_url, :last_edited_at
end
