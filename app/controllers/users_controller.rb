class UsersController < ApplicationController
  def index
    @users = User.order(:name).page(params[:page]).per(30)
  end

  def show
    @user = User.find(params[:id])

    @posts =
      @user.posts
        .order(:posted_at)
        .page(params[:page]).per(10)

    @topics =
      @user.topics
        .order(remote_id: :desc)
        .page(params[:page]).per(10)
  end
end
