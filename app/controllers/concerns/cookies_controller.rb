module CookiesController
  extend ActiveSupport::Concern
  include CookiesHelper

  included do
    after_action :attach_guest, only: :create
    after_action :remember_user, only: :create
  end

  private def attach_guest
    current_person_in_cookies.attach_to_user(current_user) if current_user.present? && current_person_in_cookies.is_a?(Guest)
  end

  private def remember_user
    remember(current_user) if current_user.present? && params[:remember_me] == '1' || params[:remember] == '1'
  end
end
