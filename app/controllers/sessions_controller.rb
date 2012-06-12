class SessionsController < ApplicationController

  def new
    redirect_to expenses_path if current_user
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])

      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end

      if user.groups.blank?
        redirect_to welcome_path
      else
        redirect_to expenses_path  
      end

    else
      flash.now[:error] = "Invalid email or password"
      render :new
    end

  end

  def destroy    
    cookies.delete(:auth_token)
    redirect_to root_url
  end

end
