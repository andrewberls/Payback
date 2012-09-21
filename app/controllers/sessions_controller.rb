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

      return redirect_to (user.groups.blank?) ? welcome_path : expenses_path
    else
      flash.now[:error] = "Invalid email or password"
      return render :new
    end

  end

  def destroy
    cookies.delete(:auth_token)
    return redirect_to root_url
  end

end
