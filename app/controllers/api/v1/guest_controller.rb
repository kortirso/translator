module Api
    module V1
        class GuestController < Api::V1::BaseController
            skip_before_action :authenticate
            before_action :authenticate_as_guest, except: %i[access_token]
            before_action :select_tasks, only: %i[index]
            before_action :select_task, only: %i[destroy]

            def access_token
                render json: { access_token: TokenService.call }, status: 201
            end

            def index
                render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(@tasks, each_serializer: TaskSerializer) }, status: 200
            end

            def create
                task = Task.new(task_params.merge(uid: params[:access_token]))
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

            def task_params
                params.require(:task).permit(:file, :to)
            end

            def select_tasks
                @tasks = Task.for_guest(params[:access_token])
            end

            def select_task
                @task = Task.for_guest(params[:access_token]).find_by(id: params[:id])
                render json: { error: 'Task not found' }, status: 404 if @task.nil?
            end

            def authenticate_as_guest
                render json: { error: 'Unauthorized guest' }, status: 401 if params[:access_token].nil? || params[:access_token].size != TokenService::KEY_SIZE * 2
            end
        end
    end
end
