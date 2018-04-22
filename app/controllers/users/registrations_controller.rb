module Users
  class RegistrationsController < Devise::RegistrationsController
    include CookiesController

    skip_before_action :verify_authenticity_token
  end
end
