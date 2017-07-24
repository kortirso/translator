class TranslationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :user_is_translator?, only: %i[index]
    before_action :user_task?, only: %i[create]
    before_action :find_task, only: %i[create]

    def index; end

    def create
        @task.activate(translation_params)
        redirect_to tasks_path
    end

    private

    def find_task
        @task = current_user.tasks.find_by(id: params[:task_id])
        head :ok if @task.nil?
    end

    def translation_params
        params.require(:translation).permit!.to_h
    end

    def user_task?
        head :ok if current_user.nil?
    end

    def user_is_translator?
        render_not_found unless current_user.try(:editor?)
    end
end
