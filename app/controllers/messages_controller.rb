class MessagesController < ApplicationController
  def index
    @messages =
      Message
        .preload(:user)
        .order(remote_created_at: :desc)
        .page(params[:page]).per(30)
  end
end
