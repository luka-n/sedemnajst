class UsersController < ApplicationController
  def index
    @users = User.order(:name).page(params[:page]).per(30)
  end

  def show
    @user = User.find(params[:id])

    @topics =
      @user.topics
        .order(:remote_created_at)
        .page(params[:page]).per(10)
  end
end
