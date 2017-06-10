module Api
    module V1
        class BaseController < ApplicationController
            private

            def authenticate_token
                @user = User.find_by(access_token: params[:access_token])
            end
        end
    end
end
