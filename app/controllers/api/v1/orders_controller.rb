# frozen_string_literal: true
class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index create show]
  before_action :set_order, only: :show

  def index
    render json: OrderSerializer.new(current_user.orders,{include: %i[user products]}).serializable_hash, status: :ok
  end

  def show
    render json: OrderSerializer.new(@order,{include: %i[user products]}).serializable_hash, status: :ok
  end

  def create
    order = current_user.orders.build(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def check_login
    unless current_user
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end

  def order_params
    params.require(:order).permit(products_id:[])
  end
end
