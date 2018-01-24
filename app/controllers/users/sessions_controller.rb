module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: %i[create destroy]
    after_action :update_token, only: :create

    private def update_token
      current_user.update_token(session[:guest])
    end
  end
end
