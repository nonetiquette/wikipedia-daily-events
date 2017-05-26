class Api::V1::WikipediaEventsController < Api::ApiBaseController
  respond_to :json
  caches_action :index, format: :json, layout: false
  etag { request.format.to_s }

  before_action only: :index do
    expires_in 10.minutes, :public => true
    @permalink = WikipediaDateHelper.normalize_permalink(params[:wikipedia_date_occurrence_date_permalink])
    validate_occurence_date_param(@permalink)
  end

  def index
    wikipedia_service = ::WikipediaService.new(@permalink)
    wikipedia_service.find_or_create
    @wikipedia_events = wikipedia_service.wikipedia_events
    if stale?(@wikipedia_events, public: true, template: false)
      respond_with @wikipedia_events
    end
  end

end