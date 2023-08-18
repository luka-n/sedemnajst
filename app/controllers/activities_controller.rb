class ActivitiesController < ApplicationController
  def index
    @activities_q = Activity.ransack(params[:q])
    @activities_q.sorts = "remote_created_at desc" if @activities_q.sorts.empty?
    @activities =
      @activities_q
        .result(distinct: true)
        .preload(:source, :user)
        .page(params[:page]).per(50)
    if @activities.respond_to?(:with_pg_search_highlight)
      @activities = @activities.with_pg_search_highlight
    end
  end
end
