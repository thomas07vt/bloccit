class TopicsController < ApplicationController
  def index
    @topics = Topic.all
    authorize(@topics)
  end

  def new
    @topic = Topic.new
    authorize(@topic)
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize(@topic)
  end

  def create
    @topic = Topic.new(params.require(:topic).permit(:name, :description, :public))
    authorize(@topic)
    if @topic.save
      flash[:notice] = "Topic was created."
      redirect_to @topic
    else
      flash[:error] = "There was an error creating the topic. Please try again."
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:id])
    authorize(@topic)
    if @topic.update_attributes(params.require(:topic).permit(:name, :description, :public))
      flash[:notice] = "Topic was updated."
      redirect_to @topic
    else
      flash[:error] = "There was an error updating the topic. Please try again."
      render :new
    end
  end
end
