module Api
    module V1
        class TasksController < Api::V1::BaseController
            before_action :select_tasks, only: %i[index]
            before_action :select_task, only: %i[destroy]

            def index
                render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, each_serializer: TaskSerializer) }, status: 200
            end

            def create
                task = Task.new(task_params.merge(user: @user))
                if task.save
                    render json: task, status: 201
                else
                    render json: { error: 'Task creation error' }, status: 409
                end
            end

            def destroy
                @task.destroy
                render json: { success: 'Task destroyed successfully' }, status: 200
            end

            private

            def select_tasks
                @tasks = @user.tasks.order(id: :desc)
            end

            def select_task
                @task = Task.find_by(id: params[:id])
                render json: { error: 'Task not found' }, status: 404 if @task.nil?
            end
        end
    end
end
