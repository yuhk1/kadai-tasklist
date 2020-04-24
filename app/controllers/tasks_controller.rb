class TasksController < ApplicationController
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
    @tasks = current_user.tasks
    end
  end

  def show
    #@task = Task.find_by(id: params[:id])
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = '投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = '投稿に失敗しました。'
      render :new
    end
  end

  def edit
    #@task = Task.find(params[:id])
  end

  def update
    #@task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
   # @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end

  private
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end