module Users
    class OmniauthController < ApplicationController
        def localized
            session[:omniauth_login_locale] = I18n.locale
            path = case params[:provider]
                when 'facebook' then user_facebook_omniauth_authorize_path
                when 'github' then user_github_omniauth_authorize_path
            end
            redirect_to path
        end
    end
end