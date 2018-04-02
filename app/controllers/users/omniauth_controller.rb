module Users
  class OmniauthController < ApplicationController
    def localized
      session[:omniauth_login_locale] = I18n.locale
      redirect_to provider_path
    end

    private def provider_path
      case params[:provider]
        when 'facebook' then user_facebook_omniauth_authorize_path
        when 'github' then user_github_omniauth_authorize_path
        else root_path
      end
    end
  end
end
