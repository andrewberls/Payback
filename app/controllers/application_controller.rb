class ApplicationController < ActionController::Base
  
  protect_from_forgery
  force_ssl

  def check_auth    
    redirect_to login_path unless current_user
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

end
