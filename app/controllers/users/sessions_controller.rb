module Users
  class SessionsController < Devise::SessionsController
    include CookiesHelper

    skip_before_action :verify_authenticity_token
    before_action :forget_user, only: :destroy
    after_action :update_token, only: :create

    private def forget_user
      forget(current_user) if current_user.present?
    end

    private def update_token
      current_user.update_token if current_user.present?
    end
  end
end
