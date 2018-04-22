module Users
  class SessionsController < Devise::SessionsController
    include CookiesController

    skip_before_action :verify_authenticity_token
    before_action :forget_user, only: :destroy

    private def forget_user
      forget(current_user) if current_user.present?
    end
  end
end
