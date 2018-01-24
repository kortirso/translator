class TranslationsController < ApplicationController
  before_action :user_is_translator?, only: %i[index]

  def index; end

  private def user_is_translator?
    render_not_found unless current_user.try(:editor?)
  end
end
