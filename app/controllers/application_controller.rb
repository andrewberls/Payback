class ApplicationController < ActionController::Base
  
  protect_from_forgery

  ACCESS_DENIED_PATH = '/expenses'

  def must_be_logged_in
    respond_to do |format|
      format.html { return redirect_to login_path unless current_user }
      format.json { return render json: {} unless current_user }
    end
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def signed_in?
    !current_user.nil?
  end
  helper_method :signed_in?

end
