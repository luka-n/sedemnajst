class UsersController < ApplicationController
  def index
    @sort_column =
      %w[name posts_count topics_count messages_count]
        .include?(params[:sort]) ?
        params[:sort] : "name"

    @sort_direction =
      %w[asc desc].include?(params[:sort_direction]) ?
        params[:sort_direction] : "asc"

    @users =
      User
        .order("#{@sort_column} #{@sort_direction}")
        .page(params[:page]).per(30)
  end

  def show
    @user = User.find(params[:id])

    @topics =
      @user.topics
        .order(:remote_created_at)
        .page(params[:page]).per(10)
  end
end
