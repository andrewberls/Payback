class GroupsController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :user_must_be_in_group, except: [:new, :create, :index, :join, :add]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    @group.initialize_owner(current_user)

    if @group.save
      return redirect_to group_path(@group.gid)
    else
      flash.now[:error] = "Something went wrong - please check your fields and try again."
      return render :new
    end
  end


  #------------------------------
  # READ
  #------------------------------
  def index
    @groups = current_user.groups

    respond_to do |format|
      format.html { return redirect_to welcome_path if @groups.blank? }
      format.json { return render json: @groups }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        users = @group.users - (params[:others] ? [current_user] : [])
        return render json: {
          group: @group,
          users: users.as_json(except: [:password_digest, :auth_token, :updated_at])
        }
      end

    end
  end


  #------------------------------
  # UPDATE
  #------------------------------
  def edit
    return redirect_to groups_path unless current_user == @group.owner
  end

  def update
    if @group.update_attributes(params[:group])
      flash[:success] = "Group successfully updated."
      return redirect_to groups_path
    else
      flash.now[:error] = "Something went wrong - please check your fields and try again."
      return render :edit
    end
  end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
    # Need to destroy group and expenses, but preserve users
    # TODO: move this to an action on the group model and test it

    @group.expenses.each { |expense| expense.destroy }
    @group.destroy
    flash[:success] = "Group successfully deleted"
    return redirect_to groups_path
  end


  #------------------------------
  # JOIN/LEAVE
  #------------------------------
  def join
    # View
  end

  def add
    # Processing
    group = Group.find_by_gid(params[:gid])

    if group && group.authenticate(params[:password])
      if group.users.include?(current_user)
        flash.now[:error] = "You already belong to that group!"
        return render :join
      else
        group.add_user(current_user)
        flash[:success] = "You are now a member of #{group.title}!"
        return redirect_to groups_path
      end
    else
      flash.now[:error] = "Invalid ID/Password combination."
      return render :join
    end
  end

  def leave
    @group.remove_user(current_user)
    flash[:success] = "You have successfully left #{@group.title}."
    return redirect_to groups_path
  end

  private

  def user_must_be_in_group
    @group = Group.find_by_gid(params[:id])
    authorized = @group.present? && @group.users.include?(current_user)
    reject_unauthorized(authorized)
  end

end
