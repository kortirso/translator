class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          tasks: ActiveModel::Serializer::CollectionSerializer.new(find_tasks, each_serializer: TaskSerializer),
          locales: ActiveModel::Serializer::CollectionSerializer.new(Locale.order(code: :asc), each_serializer: LocaleSerializer),
          frameworks: ActiveModel::Serializer::CollectionSerializer.new(Framework.order(name: :asc), each_serializer: FrameworkSerializer)
        }, status: 200
      end
    end
  end

  private def find_tasks
    return current_user.tasks.order(id: :desc) if user_signed_in?
    Task.for_guest(session[:guest])
  end
end
