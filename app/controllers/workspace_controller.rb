class WorkspaceController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          tasks: ActiveModel::Serializer::CollectionSerializer.new(find_tasks, each_serializer: TaskSerializer)
        }, status: 200
      end
    end
  end

  private def find_tasks
    Current.person.tasks.order(id: :desc).with_attached_result_file
  end
end
