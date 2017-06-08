class TranslationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :check_user_signed
    before_action :find_task, only: :create

    def index

    end

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
end
