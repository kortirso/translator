class RagistrationsController < Devise::RagistrationsController
    skip_before_action :verify_authenticity_token, only: :create
    after_action :update_token, only: :create

    private

    def update_token
        current_user.update(access_token: Devise.friendly_token(32))
    end
end