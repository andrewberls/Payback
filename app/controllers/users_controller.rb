class UsersController < ApplicationController

  before_filter :must_be_logged_in, except: [:new, :create]
  before_filter :user_must_be_current, only: [:show, :edit, :update, :destroy]
  before_filter :user_must_be_in_current_groups, only: [:debts, :credits]

  # ALL: new create show edit update destroy welcome debts credits
  # MUST BE SELF: edit update destroy
  # USER MUST BE IN GROUPS (NOT SELF): show, debts, credits

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
    # Currently not a user-available action
    return redirect_to expenses_path
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
    # Currently not a user-available action
    user = User.find(params[:id])
    user.destroy if user == current_user
    reset_session
    return redirect_to login_path
  end

  def welcome
    # First time login - belong to no groups
    #return redirect_to expenses_path unless current_user.groups.blank?
  end

  def debts
    # Condensed debts to a specific user (can't be blank or current user)
    @debts = current_user.active_debts_to(@user)
    can_view_page = @user != current_user && @debts.present?
    reject_unauthorized(can_view_page)
  end

  def credits
    # Condensed debts to a specific user (can't be blank or current user)
    @credits = current_user.active_credits_to(@user)
    can_view_page = @user != current_user && @credits.present?
    reject_unauthorized(can_view_page)
  end

  private

  def user_must_be_current
    @user = User.find_by_id(params[:id])
    authorized = @user == current_user
    reject_unauthorized(authorized)
  end

  def user_must_be_in_current_groups
    @user = User.find_by_id(params[:id])
    aggregate_users = current_user.groups.collect { |g| g.users }.flatten
    authorized = @user.present? && aggregate_users.include?(@user)
    reject_unauthorized(authorized)
  end

end
