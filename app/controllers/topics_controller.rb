class TopicsController < ApplicationController
  def index
    @topics =
      Topic
        .preload(:user)
        .order(remote_id: :desc)
        .page(params[:page]).per(50)
  end

  def show
    @topic = Topic.find(params[:id])
    @posts =
      @topic.posts
        .preload(:user)
        .order(:remote_created_at)
        .page(params[:page]).per(30)
  end
end
