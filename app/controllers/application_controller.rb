class ApplicationController < ActionController::Base
  include Authentication

  before_action :initialize_posts_q

  # bootstrap alert types
  add_flash_types :primary,
                  :secondary,
                  :success,
                  :danger,      # alias: alert
                  :warning,
                  :info,        # alias: notice
                  :light,
                  :dark

  private

  def initialize_posts_q
    @posts_q = Post.ransack
  end
end
