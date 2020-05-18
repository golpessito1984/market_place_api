# frozen_string_literal: true

class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index create show]
  before_action :set_order, only: :show

  def index
    orders = current_user.orders
                 .page(current_page)
                 .per(per_page)

    options = { links: { first: api_v1_orders_path(page: 1),
                         last: api_v1_orders_path(page: orders.total_pages),
                         prev: api_v1_orders_path(page: orders.prev_page),
                         next: api_v1_orders_path(page: orders.next_page) },
                include: %i[user products] }

    render json: OrderSerializer.new(orders, options).serializable_hash, status: :ok
  end

  def show
    render json: OrderSerializer.new(@order, { include: %i[user products] }).serializable_hash, status: :ok
  end

  def create
    order = Order.create! user: current_user
    order.build_placements_with_product_ids_and_quantities(order_params.to_h["product_ids_and_quantities"])

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
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end

  def order_params
    params.require(:order).permit(product_ids_and_quantities: [:product_id, :quantity])
  end
end
