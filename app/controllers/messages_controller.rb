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

  def show
    message = Message.find(params[:id])
    message_ids = Message.order(remote_created_at: :desc).pluck(:id)
    message_page = ((message_ids.index(message.id) + 1) / 30.0).ceil
    redirect_to messages_path(page: message_page, anchor: helpers.dom_id(message))
  end
end
