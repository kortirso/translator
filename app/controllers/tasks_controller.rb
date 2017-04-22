class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create
    before_action :check_user_signed, only: :show
    before_action :find_task, only: :show

    def index
        @locale_list = Locale.all.collect { |loc| loc.code }
    end

    def show

    end
    
    def create
        task = Task.create(task_params.merge(uid: session[:guest], user: current_user))
        TaskProcessingJob.perform_later(task)
        redirect_to translations_path
    end

    private

    def task_params
        params.require(:task).permit(:to, :file)
    end

    def find_task
        @task = current_user.tasks.find_by(id: params[:id])
        render_not_found if @task.nil?
    end
end
