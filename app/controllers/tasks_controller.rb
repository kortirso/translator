class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create
    
    def create
        task = Task.create(task_params.merge(uid: session[:guest], user: current_user))
        TaskProcessingJob.perform_later(task)
        redirect_to translations_path
    end

    private

    def task_params
        params.require(:task).permit(:to, :file)
    end
end
