module Workspace
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :find_task, only: %i[show]

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

    def show; end

    private def find_tasks
      Current.person.tasks.order(id: :desc).with_attached_result_file
    end

    private def find_task
      @task = Current.person.tasks.find_by(id: params[:id])
      render_not_found if @task.nil?
    end
  end
end
