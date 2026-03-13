class SettingsController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(settings_params)
      redirect_to settings_path, notice: "Your profile has been updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
