class MessagesController < ApplicationController
  def index
    @q = Message.ransack(params[:q])
    @q.sorts = "remote_created_at desc" if @q.sorts.empty?
    @messages =
      @q.result(distinct: true)
        .preload(:user)
        .page(params[:page]).per(30)
  end
end
