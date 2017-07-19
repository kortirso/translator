module Api
    module V1
        class TasksController < Api::V1::BaseController
            before_action :select_tasks, only: :index
            before_action :select_task, only: :destroy

            def index
                render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, each_serializer: TaskSerializer) }
            end

            def create

            end

            def destroy
                @task.destroy
                render json: {success: 'Task destroyed successfully'}, status: 200
            end

            private

            def select_tasks
                @tasks = @user.tasks.order(id: :desc)
            end

            def select_task
                @task = Task.find_by(id: params[:id])
                render json: {error: 'Task not found'}, status: 404 if @task.nil?
            end
        end
    end
end
