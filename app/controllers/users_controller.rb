class UsersController < ApplicationController

  before_filter :check_auth, except: [:new, :create]
    
  def new
    redirect_to expenses_path if current_user
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
  	@user = User.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json do
    #     render :json => { @user.as_json(except: [:password_digest, :auth_token, :updated_at]) }
    #   end
    # end

  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to login_path
  end

  def welcome
    # First time login - belong to no groups
    return redirect_to groups_path unless current_user.groups.blank?
  end

end
