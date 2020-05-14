# frozen_string_literal: true
class Api::V1::TokensController < ApplicationController

  def create
    user = User.find_by_email(user_params[:email])
    if user&.authenticate(user_params[:password])
      render json: {token: JwtWebToken.encode({user_id: user.id}),
                    email: user.email}, status: :ok
    else
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
