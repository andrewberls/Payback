class SessionsController < ApplicationController

  def new
    return redirect_to expenses_path if signed_in?
  end

  def create
    user = User.find_by_email(params[:email])

    authenticated = false
    if user && user.authenticate(params[:password])
      authenticated = true
      login_user(user)
    end

    respond_to do |format|
      format.html { handle_html_auth(authenticated) }
      format.json { handle_json_auth(authenticated) }
    end

  end

  def destroy
    cookies.delete(:auth_token)
    return redirect_to root_url
  end

  def forgot_password
    # Send email with generated reset token

    if request.post?
      email  = params[:email]
      user   = User.find_by_email(email)
      unauth = signed_in? && email != current_user.email

      if user.blank? || unauth
        flash.now[:error] = "Invalid email."
        return render :forgot_password
      end

      token = user.generate_reset_token
      PasswordsMailer.delay.reset(token.id)
      flash[:success] = "A email has been sent to #{user.email} with instructions on resetting your password!"
      return redirect_to forgot_password_path
    end
  end

  before_filter :find_reset_token, only: :reset_password
  def reset_password
    # Reset a user's password

    if request.post?
      return redirect_bad_token if @token.blank? || @token.invalid?

      password = params[:password]
      if password != params[:password_confirmation]
        @user.errors.add :password, "doesn't match confirmation"
        return render :reset_password
      end

      if @user.update_attributes(password: password)
        @token.mark_used
        login_user(@user)
        flash[:success] = "Password successfully reset!"
        return redirect_to expenses_path
      else
        return render :reset_password
      end
    end
  end

  private

  def redirect_to_return_or_path(path)
    redirect_to(session[:return_to] || path)
    clear_return_to
  end

  def clear_return_to
    session.delete(:return_to)
  end

  def find_reset_token
    @token = ResetToken.find_by_token(params[:token])
    return redirect_bad_token if @token.blank? || @token.invalid?

    @user  = @token.user
  end

  def redirect_bad_token
    flash[:error] = "Token is invalid."
    return redirect_to forgot_password_path
  end

  def handle_html_auth(authenticated)
    if authenticated
      path = (current_user.groups.blank?) ? new_group_path : expenses_path
      return redirect_to_return_or_path(path)
    else
      flash.now[:error] = "Invalid email or password"
      return render :new
    end
  end

  def handle_json_auth(authenticated)
    if authenticated
      render json: { token: current_user.auth_token }
    else
      render text: 'Forbidden', status: '403'
    end
  end

end
