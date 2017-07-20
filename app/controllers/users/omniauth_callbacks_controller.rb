module Users
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        before_action :provides_callback

        def facebook; end

        private

        def provides_callback
            return redirect_to root_path, flash: { error: 'Access Error' } if request.env['omniauth.auth'].nil?
            @user = User.find_for_oauth(request.env['omniauth.auth'])
            if @user
                @user.update_token
                sign_in_and_redirect @user, event: :authentication
            else
                redirect_to root_path, flash: { manifesto_username: true }
            end
        end
    end
end
