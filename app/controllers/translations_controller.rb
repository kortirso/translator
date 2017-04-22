class TranslationsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create
    before_action :find_task

    def create
        TranslationsRebuildService.call({translations: translation_params, task: @task})
        redirect_to @task
    end

    private

    def find_task
        @task = Task.find(params[:task_id].to_i)
    end

    def translation_params
        params.require(:translation).permit!
    end
end
