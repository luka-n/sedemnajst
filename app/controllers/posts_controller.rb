class PostsController < ApplicationController
  def index
    @posts_q = Post.ransack(params[:q])
    @posts_q.sorts = "remote_created_at desc" if @posts_q.sorts.empty?
    @posts =
      @posts_q.result(distinct: true)
        .preload(:user, topic: :user)
        .page(params[:page]).per(50)
    if @posts.respond_to?(:with_pg_search_highlight)
      @posts = @posts.with_pg_search_highlight
    end
  end

  def show
    post = Post.includes(:topic).find(params[:id])
    topic_post_ids = post.topic.posts.order(:remote_created_at).pluck(:id)
    topic_page = ((topic_post_ids.index(post.id) + 1) / 30.0).ceil
    redirect_to topic_path(post.topic, page: topic_page, anchor: helpers.dom_id(post))
  end
end
