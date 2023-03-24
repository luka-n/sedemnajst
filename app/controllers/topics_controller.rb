class TopicsController < ApplicationController
  def index
    @sort_column =
      %w[remote_created_at title posts_count last_post_remote_created_at]
        .include?(params[:sort]) ?
        params[:sort] : "last_post_remote_created_at"

    @sort_direction =
      %w[asc desc].include?(params[:sort_direction]) ?
        params[:sort_direction] : "desc"

    @topics =
      Topic
        .preload(:user, last_post: :user)
        .order("#@sort_column #@sort_direction")
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
