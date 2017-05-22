class Api::ApiBaseController < ApplicationController
  respond_to :json

  rescue_from ::ApiInvalidParametersError, with: :unprocessable_entity
  rescue_from ::ExternalPageNotFoundError, with: :not_found
  rescue_from ::ExternalPageUnprocessableEntityError, with: :unprocessable_entity
  rescue_from ::ExternalPageInternalServerError, with: :internal_server_error

private

  def validate_occurence_date_param(occurence_date_permalink)
    wikipedia_date = WikipediaDate::OccurenceDatePermalinkValidator.new(occurence_date_permalink)
    if !wikipedia_date.valid?
      raise ::ExternalPageUnprocessableEntityError.new("Invalid parameters: #{wikipedia_date.errors.full_messages.join(',')}")
    end
  end

  def not_found(error)
    render :json => {:error => error.message}, :status => :not_found
  end 

  def unprocessable_entity(error)
    render :json => {:error => error.message}, :status => :unprocessable_entity
  end 

  def internal_server_error(error)
    render :json => {:error => error.message}, :status => :internal_server_error
  end
end