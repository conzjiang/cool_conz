class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    render :index
  end

  def show
    @comment = Comment.find(params[:id])
    render :show
  end

  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to comments_url
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    render :edit
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to comment_url(@comment)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to comments_url
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
