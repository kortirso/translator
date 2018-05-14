class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          tasks: ActiveModel::Serializer::CollectionSerializer.new(find_tasks, each_serializer: TaskSerializer),
          locales: Locale.list,
          frameworks: ActiveModel::Serializer::CollectionSerializer.new(Framework.order(name: :asc), each_serializer: FrameworkSerializer)
        }, status: 200
      end
    end
  end

  private def find_tasks
    Current.person.tasks.order(id: :desc).limit(10).with_attached_result_file
  end
end
