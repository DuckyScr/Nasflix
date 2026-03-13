class ApplicationController < ActionController::Base
  before_action :check_setup!
  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def require_admin
    unless logged_in? && current_user.admin?
      redirect_to root_path, alert: "You must be an admin to access this page."
    end
  end

  def require_admin_or_parent
    unless logged_in? && (current_user.admin? || current_user.parent?)
      redirect_to root_path, alert: "You do not have permission to access this page."
    end
  end

  def check_setup!
    redirect_to setup_path unless User.exists?
  end
end
