class TasksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[create update]
    before_action :find_task, only: %i[show update destroy]
    before_action :check_task_status, only: %i[show]

    def index
        respond_to do |format|
            format.html
            format.json do
                render json: {
                    tasks: ActiveModel::Serializer::CollectionSerializer.new(find_tasks, each_serializer: TaskSerializer),
                    locales: ActiveModel::Serializer::CollectionSerializer.new(Locale.all.order(code: :asc), each_serializer: LocaleSerializer),
                    frameworks: ActiveModel::Serializer::CollectionSerializer.new(Framework.all.order(name: :asc), each_serializer: FrameworkSerializer)
                }, status: 200
            end
        end
    end

    def show
        @translations = @task.translations.includes(:base, :result).order(id: :asc)
        @locale = Locale.find_by(code: @task.to)
    end

    def create
        task = Task.new(create_task_params)
        if task.save
            render json: task, status: 201
        else
            render json: { error: 'Task creation error' }, status: 409
        end
    end

    def update
        @task.activate(task_params)
        redirect_to tasks_path
    end

    def destroy
        @task.destroy
        render json: { success: 'Task destroyed successfully' }, status: 200
    end

    private

    def task_params
        resp = params.permit(:file, :framework, :to).to_h
        resp['framework'] = Framework.find_by(name: resp[:framework])
        resp
    end

    def create_task_params
        return task_params.merge(user: current_user) if user_signed_in?
        task_params.merge(uid: session[:guest])
    end

    def find_tasks
        return current_user.tasks.order(id: :desc) if user_signed_in?
        Task.for_guest(session[:guest])
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
