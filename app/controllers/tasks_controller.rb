class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create
    before_action :find_task, only: :show
    before_action :check_file, only: :create

    def index
        @locale_list = Locale.get_list
    end

    def show
        @translations = @task.translations.includes(:base, :result).order(id: :asc)
    end
    
    def create
        Task.create(task_params.merge(uid: session[:guest], user: current_user))
        redirect_to tasks_path
    end

    private

    def task_params
        params.require(:task).permit(:to, :file)
    end

    def find_task
        if user_signed_in?
            @task = current_user.tasks.find_by(id: params[:id])
        else
            @task = Task.find_by(id: params[:id], uid: session[:guest])
        end
        render_not_found if @task.nil?
    end

    def check_file
        redirect_to tasks_path if params[:task][:file].nil?
    end
end
