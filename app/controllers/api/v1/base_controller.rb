module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session, if: -> { request.format.json? }
      before_action :authenticate

      private def authenticate
        @user = User.find_by(email: params[:email], access_token: params[:access_token])
        render json: { error: 'Unauthorized' }, status: 401 if @user.nil?
      end
    end
  end
end
