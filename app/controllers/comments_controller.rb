class CommentsController < ApplicationController
  respond_to :html, :js

  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:post_id])
    @comment.post = @post

    if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@post.topic, @post] 
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      #store error message in session
      flash[:comment_errors] = @comment.errors[:body]
      redirect_to [@post.topic, @post]
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])
    authorize @comment

    if @comment.destroy
      flash[:notice] = "Comment was removed."
    else
      flash[:error] = "Comment couldn't be deleted. Try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end

end
