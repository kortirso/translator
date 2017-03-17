class TasksController < ApplicationController
    def create
        Task.create(task_params.merge(uid: session[:guest]))
    end

    private

    def task_params
        params.require(:task).permit(:from, :to, :file)
    end
end
