module Users
  class OmniauthController < ApplicationController
    def localized(path = root_path)
      session[:omniauth_login_locale] = I18n.locale
      case params[:provider]
        when 'facebook' then path = user_facebook_omniauth_authorize_path
        when 'github' then path = user_github_omniauth_authorize_path
      end
      redirect_to path
    end
  end
end
