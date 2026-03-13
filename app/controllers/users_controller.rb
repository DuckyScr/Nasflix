class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    @users = User.all.order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = params[:user][:role] if current_user.admin? && params[:user][:role].present?
    if @user.save
      redirect_to users_path, notice: "User '#{@user.name}' was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params.except(:role))
      redirect_to users_path, notice: "User '#{@user.name}' was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete yourself."
    else
      @user.destroy
      redirect_to users_path, notice: "User was successfully deleted."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
