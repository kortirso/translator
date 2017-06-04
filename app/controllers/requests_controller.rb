class RequestsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :check_user_signed

    def create
        request = current_user.requests.new body: request_params[:body]
        @success = request.save
    end

    def request_params
        params.require(:request).permit(:body)
    end
end
