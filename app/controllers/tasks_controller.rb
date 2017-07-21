class TasksController < ApplicationController
    before_action :find_task, only: :show
    before_action :check_task_status, only: :show

    def index; end

    def show
        @translations = @task.translations.includes(:base, :result).order(id: :asc)
        @locale = Locale.find_by(code: @task.to)
    end

    private

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
