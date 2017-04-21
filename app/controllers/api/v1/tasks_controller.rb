class Api::V1::TasksController < Api::V1::BaseController
    def index
        tasks = Task.for_guest(session[:guest]).order(id: :asc)
        render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(tasks, each_serializer: TaskSerializer) }
    end
end