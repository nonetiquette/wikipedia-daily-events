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

class WikipediaDate < ActiveRecord::Base
  include ActiveModel::Validations

  has_many :events, class_name: 'WikipediaEvent', dependent: :destroy

  MINIMUM_OCCURRED_ON_DATE = Date.new(2000,1,1)
  BASE_URL = 'https://en.wikipedia.org/wiki/Portal:Current_events/'
  PERMALINK_DATE_FORMAT = '%Y_%B_%e'

  validates :occurred_on, presence: true, uniqueness: true
  validates :permalink, presence: true, uniqueness: {case_sensitive: false}
  validates :page_url, presence: true, uniqueness: {case_sensitive: false}
  validates_with WikipediaDate::OccurredOnValidator

  scope :by_occurred_on, -> { order(:occurred_on) }
end
