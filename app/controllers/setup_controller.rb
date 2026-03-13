class SetupController < ApplicationController
  skip_before_action :check_setup!
  skip_before_action :require_login
  layout "application"

  def new
    if User.exists?
      redirect_to root_path
      return
    end
    @user = User.new
  end

  def create
    if User.exists?
      redirect_to root_path
      return
    end

    @user = User.new(setup_params)
    @user.role = "admin"

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Nasflix! Your admin account is ready."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def setup_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
