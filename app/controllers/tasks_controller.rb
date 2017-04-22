class TasksController < ApplicationController
    def create
        begin
            Task.create!(task_params.merge(uid: session[:guest]))
        rescue ActiveRecord::RecordInvalid => invalid
            puts invalid.record.errors
        end
        redirect_to translations_path
    end

    private

    def task_params
        params.require(:task).permit(:to, :file)
    end
end
