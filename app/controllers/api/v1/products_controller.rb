# frozen_string_literal: true
class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show destroy update]
  before_action :check_login, only: %i[create destroy update]
  before_action :check_owner, only: %i[destroy update]

  def show
    render json: ProductSerializer.new(@product,{include: [:user]}).serializable_hash, status: :ok
  end

  def index
    products = Product.page(params[:page])
                      .per(params[:per_page])
                      .search(search_params)

    options = { links: { first: api_v1_products_path(page: 1),
                         last: api_v1_products_path(page: products.total_pages),
                         prev: api_v1_products_path(page: products.prev_page),
                         next: api_v1_products_path(page: products.next_page) } }

    render json: ProductSerializer.new(products, options).serializable_hash, status: :ok
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: ProductSerializer.new(product).serializable_hash, status: :created
    else
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {}, status: :no_content
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def check_login
    unless current_user
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end

  def check_owner
    if @product.user_id == current_user&.id
      true
    else
      render json: {errors: 'Forbidden action'}, status: :forbidden
    end
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def search_params
    params[:search] ? params.require(:search).permit(:keyboard, :min_price, :max_price) : { }
  end

end
