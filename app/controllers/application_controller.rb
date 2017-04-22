class ApplicationController < ActionController::Base
    helper Webpacker::Helper
    
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from ActionController::RoutingError, with: :render_not_found

    before_action :set_locale
    before_action :set_user_session

    def catch_404
        raise ActionController::RoutingError.new(params[:path])
    end

    private

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    end

    def render_not_found
        render template: 'shared/404', status: 404
    end

    def set_locale
        I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end

    def set_user_session
        session[:guest] = Digest::MD5.hexdigest(Time.current.to_s) if session[:guest].nil? || !user_signed_in?
    end

    def check_user_signed
        return true if user_signed_in?
        render template: 'shared/need_signup'
    end
end
