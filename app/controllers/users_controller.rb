class UsersController < ApplicationController

  before_filter :must_be_logged_in, except: [:new, :create]
  before_filter :check_access, except: [:new, :create, :welcome]
    
  def new
    return redirect_to expenses_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      cookies[:auth_token] = @user.auth_token
      return redirect_to welcome_path
    else
      return render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user.as_json }
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated."
      return redirect_to expenses_path      
    else
      flash.now[:error] = "Something went wrong - please check your fields and try again."
      return render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy if user == current_user
    reset_session
    return redirect_to login_path
  end

  def welcome
    # First time login - belong to no groups
    return redirect_to expenses_path unless current_user.groups.blank?
  end

  private

  def check_access
    # Check if a user is allowed to perform a modification action
    @user = User.find(params[:id])
    authorized = @user == current_user

    respond_to do |format|
      format.html { redirect_to expenses_path unless authorized }
      format.json { render json: {} unless authorized }
    end
  end

end
