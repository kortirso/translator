class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create update destroy]
  before_action :find_task, only: %i[update destroy]
  before_action :check_task_status, only: %i[destroy]

  def index
    render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(find_tasks, each_serializer: TaskSerializer) }, status: 200
  end

  def create
    task = Task.new(task_params.merge(personable: Current.person))
    if task.save!
      render json: task, status: 201
    else
      render json: { error: 'Task creation error' }, status: 409
    end
  end

  def update
    @task.activate
    redirect_to tasks_path
  end

  def destroy
    @task.destroy
    render json: { success: 'Task destroyed successfully' }, status: 200
  end

  private def task_params
    resp = params.permit(:file, :framework, :from, :to).to_h
    resp['framework'] = Framework.find_by(name: resp[:framework])
    resp
  end

  private def find_tasks
    Current.person.tasks.order(id: :desc).with_attached_result_file
  end

  private def find_task
    @task = Current.person.tasks.find_by(id: params[:id])
    render_not_found if @task.nil?
  end

  private def check_task_status
    render_not_found unless @task.completed? || @task.failed?
  end
end
