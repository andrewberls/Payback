class ApplicationController < ActionController::Base
  
  protect_from_forgery

  ACCESS_DENIED_PATH = '/expenses'

  def must_be_logged_in
    reject_unauthorized(signed_in?, login_path)
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

  def reject_unauthorized(authorized, path=ACCESS_DENIED_PATH)
    respond_to do |format|
      format.html { return redirect_to path unless authorized }
      format.json { return render json: {} unless authorized }
    end
  end

end