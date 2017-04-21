class TasksController < ApplicationController
    def index
        tasks = Task.for_guest(session[:guest]).order(id: :asc)
        render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(tasks, each_serializer: TaskSerializer) }
    end

    def create
        Task.create(task_params.merge(uid: session[:guest]))
    end

    private

    def task_params
        params.require(:task).permit(:from, :to, :file)
    end
end
