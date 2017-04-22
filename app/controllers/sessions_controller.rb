require 'securerandom'

class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: :create
    after_action :update_token, only: :create

    private

    def update_token
        current_user.update(access_token: SecureRandom.hex(32))
    end
end