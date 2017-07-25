class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %[update]
    before_action :find_task, only: %i[show update]
    before_action :check_task_status, only: %i[show]

    def index; end

    def show
        @translations = @task.translations.includes(:base, :result).order(id: :asc)
        @locale = Locale.find_by(code: @task.to)
    end

    def update
        @task.activate(task_params)
        redirect_to tasks_path
    end

    private

    def task_params
        params.require(:translation).permit!.to_h
    end

    def find_task
        @task = select_task
        render_not_found if @task.nil?
    end

    def select_task
        return current_user.tasks.find_by(id: params[:id]) if user_signed_in?
        Task.find_by(id: params[:id], uid: session[:guest])
    end

    def check_task_status
        render_not_found unless @task.completed?
    end
end
