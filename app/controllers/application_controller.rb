# frozen_string_literal: true
class ApplicationController < ActionController::API
  include Paginable
  include Authenticable
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private
  def record_not_found
    render json: {errors: 'Record not found'}, status: :not_found
  end
end
