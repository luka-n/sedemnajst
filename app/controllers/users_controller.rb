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

    @q = @user.activities.ransack(params[:q])
    @q.sorts = "remote_created_at desc" if @q.sorts.empty?
    @activities =
      @q.result(distinct: true)
        .preload(:source)
        .page(params[:page]).per(30)
    if @activities.respond_to?(:with_pg_search_highlight)
      @activities = @activities.with_pg_search_highlight
    end
  end

  def stats
    @user = User.find(params[:user_id])

    @q = @user.activities.ransack(params[:q])

    @q.remote_created_at_in_date_range ||=
      [
        (Date.today - 1.week).strftime("%d.%m.%Y"),
        Date.today.strftime("%d.%m.%Y")
      ].join(" - ")

    @data_by_source_type = {}

    %w[Message Post Topic].each do |source_type|
      @data_by_source_type[source_type] =
        @q
          .result(distinct: true)
          .where(source_type: source_type)
    end
  end
end
