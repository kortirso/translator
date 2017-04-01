class Api::V1::TasksController < Api::V1::BaseController
    def index
        render json: ActiveModel::Serializer::CollectionSerializer.new(Task.for_guest(session[:guest]).order(id: :asc), each_serializer: TaskSerializer)
    end
end