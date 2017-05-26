class Api::V1::WikipediaDatesController < Api::ApiBaseController
  respond_to :json
  caches_action [:index, :show], format: :json, layout: false
  etag { request.format.to_s }
  
  before_action only: :index do
    expires_in 1.minutes, :public => true
  end

  before_action only: :show do
    expires_in 1.day, :public => true
    @permalink = WikipediaDateHelper.normalize_permalink(params[:occurrence_date_permalink])
    validate_occurence_date_param(@permalink)
  end

  def index
    @wikipedia_dates = WikipediaDate.by_occurred_on
    @wikipedia_dates_pagination = paginate @wikipedia_dates, per_page: 10

    if stale?(@wikipedia_dates, public: true, template: false)
      response = {
        data: @wikipedia_dates_pagination.map{|w| ::WikipediaDateSerializer.new(w, root: false).as_json },
        total_records: @wikipedia_dates.length
      }
      render json: response
    end
  end

  def show
    @wikipedia_date = ::WikipediaDateService.new(@permalink).find_or_create

    if stale?(@wikipedia_date, public: true, template: false)
      respond_with @wikipedia_date
    end
  end
end