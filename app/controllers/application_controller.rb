class ApplicationController < ActionController::Base

  protect_from_forgery

  ACCESS_DENIED_PATH = '/expenses'

  helper_method :current_user, :signed_in?

  def must_be_logged_in

    respond_to do |format|
      format.html {
        authorized = signed_in?
        session[:return_to] = request.fullpath unless authorized
        reject_unauthorized(authorized, path: login_path)
      }
      format.json {
        # authenticate_or_request_with_http_token do |token, options|
        #   ApiKey.exists?(access_token: token)
        # end
      }
      format.js {}
    end

  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def signed_in?
    current_user.present?
  end

  def reject_unauthorized(authorized=false, options={})
    path = options.delete(:path) || ACCESS_DENIED_PATH

    unless authorized
      logger.warn "WARNING: Unauthorized access attempt"

      respond_to do |format|
        format.html { return redirect_to path }
        format.json { return render json: {} }
      end
    end
  end

end
