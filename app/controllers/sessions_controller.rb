class SessionsController < ApplicationController

  def new
    return redirect_to expenses_path if signed_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end

      path = (user.groups.blank?) ? welcome_path : expenses_path
      return redirect_to_return_or_path(path)
    else
      flash.now[:error] = "Invalid email or password"
      return render :new
    end

  end

  def destroy
    cookies.delete(:auth_token)
    return redirect_to root_url
  end

  private

  def redirect_to_return_or_path(path)
    redirect_to(session[:return_to] || path)
    clear_return_to
  end

  def clear_return_to
    session.delete :return_to
  end

end
