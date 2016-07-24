class CommentsController < ApplicationController
  layout "comments_layout", only: [:index]
  layout "tasks_layout"
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_project
  
  ## STANDARD RESTFUL ROUTES

  def index
    @comments = @project.comments
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to task_path(@task)
    else
      @comments = @task.comments
      render 'tasks/show'
    end
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    redirect_to task_path(@task)
  end

  def destroy
    @comment.destroy
    redirect_to task_path(@task)
  end

  ## PRIVATE METHODS

  private
  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def set_task
    @task = set_comment.task
  end

  def set_project
    if params[:id]
       @project = Project.find_by(id: params[:id])
    else
      @project = Project.find_by(id: params[:project_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :task_id, :user_id)
  end
end
