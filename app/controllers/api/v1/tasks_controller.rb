class Api::V1::TasksController < Api::V1::BaseController
    before_action :authenticate_token
    before_action :select_tasks, only: :index

    def index
        render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, each_serializer: TaskSerializer) }
    end

    private

    def select_tasks
        @tasks = @user.present? ? @user.tasks.order(id: :desc) : Task.for_guest(params[:access_token]).order(id: :desc)
    end
end