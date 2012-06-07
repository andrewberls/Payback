class ApplicationController < ActionController::Base
  
  protect_from_forgery
  #force_ssl

  def check_auth    
    respond_to do |format|
      format.html { redirect_to login_path unless current_user }
      format.json { render json: {} unless current_user }
    end
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

end
