class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
  end

  def create
    @user = User.find_by("lower(name) = ?", user_params[:name].downcase)
    if @user
      if @user.has_password?
        if @user.authenticate(user_params[:password])
          login(@user)
          flash[:success] = "Pozdravljen, uporabnik #{@user.name}"
          redirect_to root_path
        else
          flash.now[:alert] = "Slabo - napacen uporabnik ali geslo"
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Ti sploh se nimas gesla, tezi zanjga uporabniku Ao"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Pa ti dobesedno ne obstajas, vstran!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
