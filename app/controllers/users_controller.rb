class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    @users =
      @q.result(distinct: true)
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
