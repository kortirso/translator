class TasksController < ApplicationController
    def create
        Task.create(task_params.merge(uid: session[:guest]))
        redirect_to translations_path
    end

    private

    def task_params
        params.require(:task).permit(:from, :to, :file)
    end
end
