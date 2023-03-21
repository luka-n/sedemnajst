class MessagesController < ApplicationController
  def index
    @messages =
      Message
        .preload(:user)
        .order(posted_at: :desc)
        .page(params[:page]).per(50)
  end
end
