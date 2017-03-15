class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    rescue_from ActionController::RoutingError, with: :render_not_found

    before_action :set_user_session

    def catch_404
        raise ActionController::RoutingError.new(params[:path])
    end

    private

    def render_not_found
        render template: 'shared/404', status: 404
    end

    def set_user_session
        session[:guest] = Digest::MD5.hexdigest(Time.current.to_s)
    end
end
