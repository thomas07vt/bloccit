class CommentsController < ApplicationController
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
      redirect_to [@post.topic, @post]
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
