class UsersController < ApplicationController
    
  def new
    redirect_to expenses_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to welcome_path
    else
      render 'new'
    end
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  end

  def destroy
  end

end
