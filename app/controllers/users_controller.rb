class UsersController < ApplicationController

  before_filter :must_be_logged_in,              except: [:new, :create]
  before_filter :user_must_be_current,           only: [:show, :edit, :update, :destroy]
  before_filter :user_must_be_in_current_groups, only: [:debts, :credits]

  def new
    return redirect_to expenses_path if signed_in?
    @user = User.new
  end

  def create
    user_params = params[:user]
    @user = User.new(user_params)

    if User.exists?(email: user_params[:email])
      flash.now[:error] = "There's already an account with that email address!"
      return render :new
    end

    if @user.save
      login_user(@user)
      return redirect_to welcome_path
    else
      flash.now[:error] = "Error - please check your fields and try again."
      return render :new
    end
  end

  def show
    respond_to do |format|
      format.json { return render json: @user }
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated."
      return redirect_to expenses_path
    else
      flash.now[:error] = "Error - please check your fields and try again."
      return render :edit
    end
  end

  def welcome
    # First time login - belong to no groups
    return redirect_to expenses_path unless current_user.brand_new?
  end

  def debts
    # Condensed debts to a specific user (can't be blank or current user)
    @debts = current_user.active_debts_to(@user)
    reject_empty_expenses(@debts)
  end

  def credits
    # Condensed debts to a specific user (can't be blank or current user)
    @credits = current_user.active_credits_to(@user)
    reject_empty_expenses(@credits)
  end

  private

  def user_must_be_current
    @user = User.find_by_id(params[:id])
    authorized = @user == current_user
    reject_unauthorized(authorized)
  end

  def user_must_be_in_current_groups
    @user   = User.find_by_id(params[:id])
    members = current_user.groups.map(&:users).flatten
    auth    = @user.present? && members.include?(@user)
    reject_unauthorized(auth)
  end

  def reject_empty_expenses(expenses)
    can_view_page = (@user != current_user) && expenses.present?
    reject_unauthorized(can_view_page)
  end

end
