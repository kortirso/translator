module Workspace
  class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[destroy]
    before_action :authenticate_user!
    before_action :find_task, only: %i[show destroy]
    before_action :check_task_status, only: %i[destroy]

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

    def show
      respond_to do |format|
        format.html
        format.json do
          render json: {
            task: TaskSerializer::FullData.new(@task)
          }, status: 200
        end
      end
    end

    def destroy
      @task.destroy
      redirect_to workspace_tasks_path, status: 303
    end

    private def find_tasks
      Current.person.tasks.order(id: :desc).with_attached_result_file
    end

    private def find_task
      @task = Current.person.tasks.find_by(id: params[:id])
      render_not_found if @task.nil?
    end

    private def check_task_status
      render_not_found unless @task.completed? || @task.failed?
    end
  end
end
