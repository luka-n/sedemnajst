module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    helper_method :current_user
  end

  private

  def authenticate
    if authenticated_user = User.find_by_id(session[:user_id])
      Current.user = authenticated_user
    else
      flash[:warning] = "Kdo gre tam? Tezi Ao, ce se nimas gesla"
      redirect_to new_session_url
    end
  end

  def current_user
    Current.user
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end
end
