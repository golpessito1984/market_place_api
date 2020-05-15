# frozen_string_literal: true
class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy update]
  before_action :check_owner, only: [:update, :destroy]

  def show
    render json: UserSerializer.new(@user, include: [:products]).serializable_hash, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user).serializable_hash, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: {}, status: :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_owner
    if @user.id == current_user&.id
      true
    else
      render json: {errors: 'Forbidden action'}, status: :forbidden
    end
  end
end
