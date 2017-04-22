Devise::SessionsController.class_eval do
   skip_before_action :verify_authenticity_token, only: [:create]
end

Devise::RegistrationsController.class_eval do
   skip_before_action :verify_authenticity_token, only: [:create]
end