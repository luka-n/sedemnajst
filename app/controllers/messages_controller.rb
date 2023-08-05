class MessagesController < ApplicationController
  def index
    @sort_column =
      %w[remote_created_at]
        .include?(params[:sort]) ?
        params[:sort] : "remote_created_at"

    @sort_direction =
      %w[asc desc].include?(params[:sort_direction]) ?
        params[:sort_direction] : "desc"

    @messages =
      Message
        .preload(:user)
        .order("#{@sort_column} #{@sort_direction}")
        .page(params[:page]).per(30)
  end
end
