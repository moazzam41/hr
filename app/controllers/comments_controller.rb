class CommentsController < ApplicationController
  layout "comments_layout", only: [:index]
  layout "tasks_layout"
  before_action :set_comment, only: [:edit, :update, :show, :destroy]
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_project
    
  ## STANDARD RESTFUL ROUTES

  def index
    if @project.owner == @user || @user.admin? || @project.collaborators.include?(@user)
      @comments = @project.comments.reverse
      respond_to do |format|
        format.html { render :index}
        format.json { render json: @comments }
      end
    else
      flash[:alert] = "You are not authorized to perform that action."
      redirect_to root_path
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @task = @comment.task
      render json: (@comment)
    else
      @comments = @task.comments
      render 'tasks/show'
    end
  end

  def show 
    render json: (@comment)
  end

  def edit
    authorize @comment
    respond_to do |format|
      format.html {render :edit}
      format.json {render json: @comment}
    end
  end

  def update
    authorize @comment
     if @comment.update(comment_params)
      @task = @comment.task
      render json: @comment
    else
      @comments = @task.comments
      render 'tasks/show'
    end
  end

  def destroy
    authorize @comment
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
