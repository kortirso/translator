class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join('frontend')

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :set_user_session

  private def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end

  private def render_not_found
    render template: 'shared/404', status: 404
  end

  private def set_user_session
    session[:guest] = TokenService.call if session[:guest].nil? && !user_signed_in?
  end
end
