class Api::V1::WikipediaEventsController < Api::ApiBaseController
  respond_to :json
  caches_action :index, format: :json, layout: false
  etag { request.format.to_s }

  before_action only: :index do
    expires_in 10.minutes, :public => true
    validate_occurence_date_param(params[:wikipedia_date_occurrence_date_permalink])
  end

  def index
    @wikipedia_date = WikipediaDate.where('permalink ~* ?', params[:wikipedia_date_occurrence_date_permalink]).first
    if @wikipedia_date.present?
      @wikipedia_events = @wikipedia_date.events
    else
      @wikipedia_date = create_wikipedia_date(params[:wikipedia_date_occurrence_date_permalink])
      @wikipedia_events = create_wikipedia_events(@wikipedia_date)
    end
    if stale?(@wikipedia_events, public: true, template: false)
      respond_with @wikipedia_events
    end
  end

  private

  def create_wikipedia_date(occurrence_date_permalink)
    ::WikipediaDateFactory.new(occurrence_date_permalink).build
  end

  def create_wikipedia_events(wikipedia_date)
    events_data = []
    event_urls = ::WikipediaDateParserService.new(wikipedia_date.page_url).parse
    event_urls.each do |url|
      begin
        attributes = ::WikipediaEventParserService.new(url).parse
        events_data << attributes
        ::WikipediaEventFactory.new(wikipedia_date.id, attributes[:permalink], attributes).build
      rescue
        # TODO: if one of them croaks, the others shouldn't, also this should be in a background job
        next
      end
    end
    events_data
  end

end