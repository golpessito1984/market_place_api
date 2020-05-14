# frozen_string_literal: true

module Authenticable
  def current_user
    authorization_token = request.headers['Authorization']
    return nil if authorization_token.nil?

    payload_user = JwtWebToken.decode(authorization_token)
    return User.find(payload_user[:user_id]) rescue
                                               ActiveRecord::RecordNotFound
  end
end
