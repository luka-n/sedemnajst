class TopicsController < ApplicationController
  def index
    @q = Topic.ransack(params[:q])
    @q.sorts = "last_post_remote_created_at desc" if @q.sorts.empty?
    @topics =
      @q.result(distinct: true)
        .preload(:user, last_post: :user)
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
