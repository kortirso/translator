module CookiesController
  extend ActiveSupport::Concern
  include CookiesHelper

  included do
    after_action :remember_user, only: :create
  end

  private def remember_user
    remember(current_user) if params[:remember_me] == '1' && current_user.present?
  end
end
