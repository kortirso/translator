class FormatsController < ApplicationController
  before_action :check_format, only: %i[show]

  def index; end

  def show
    render params[:format_name]
  end

  private def check_format
    render_not_found unless %w[rails android ios net react laravel yii].include?(params[:format_name])
  end
end
