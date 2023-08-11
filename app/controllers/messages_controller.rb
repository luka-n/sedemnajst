class MessagesController < ApplicationController
  def index
    @q = Message.ransack(params[:q])
    @q.sorts = "remote_created_at desc" if @q.sorts.empty?
    @messages =
      @q.result(distinct: true)
        .preload(:user)
        .page(params[:page]).per(30)
    if @messages.respond_to?(:with_pg_search_highlight)
      @messages = @messages.with_pg_search_highlight
    end
  end
end
