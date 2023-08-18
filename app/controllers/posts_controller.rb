class PostsController < ApplicationController
  def show
    post = Post.includes(:topic).find(params[:id])
    topic_post_ids = post.topic.posts.order(:remote_created_at).pluck(:id)
    topic_page = ((topic_post_ids.index(post.id) + 1) / 30.0).ceil
    redirect_to topic_path(post.topic, page: topic_page, anchor: helpers.dom_id(post))
  end
end
