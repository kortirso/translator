class Api::V1::TasksController < Api::V1::BaseController
    before_action :authenticate_token
    before_action :select_tasks, only: :index
    before_action :find_task, only: :show

    def index
        render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, each_serializer: TaskSerializer) }
    end

    def show
        render json: { task: TaskSerializer.new(@task) }
    end

    private

    def select_tasks
        @tasks = @user.present? ? @user.tasks.order(id: :desc) : Task.for_guest(params[:access_token]).order(id: :desc)
    end

    def find_task
        @task = Task.find_by(id: params[:id])
        render json: { error: 'Task does not exist' } if @task.nil?
    end
end