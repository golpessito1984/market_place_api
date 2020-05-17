# frozen_string_literal: true
class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index]

  def index
    render json: OrderSerializer.new(current_user.orders,{include: [:user, :products]}).serializable_hash, status: :ok
  end

  private
  def check_login
    unless current_user
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end
end
