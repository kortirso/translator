class Api::V1::TasksController < Api::V1::BaseController
    def index
        tasks = Task.for_guest(params[:access_token]).order(id: :asc)
        render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(tasks, each_serializer: TaskSerializer) }
    end
end