class GroupsController < ApplicationController

  before_filter :must_be_logged_in, except: [:invitations]
  before_filter :user_must_be_in_group, only: [:show, :edit, :update, :leave, :invite]

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


  def index
    @groups = current_user.groups

    respond_to do |format|
      format.html { return redirect_to new_group_path if @groups.blank? }
      format.json { return render json: @groups }
    end
  end

  def show
    respond_to do |format|
      format.html {
        unless current_user.owns?(@group) && @group.users.count == 1
          return redirect_to groups_path
        end
      }
      format.json {
        scope = params[:exclude_current] ? current_user : nil
        return render json: GroupSerializer.new(@group, scope: scope)
      }
    end
  end

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


  def join
    if request.post?
      group = Group.find_by_gid(params[:gid])

      if group && group.authenticate(params[:password])
        return add_user(group, current_user)
      else
        flash.now[:error] = "Invalid ID/Password combination."
        return render :join
      end
    end
  end

  def leave
    @group.remove_user(current_user)
    flash[:success] = "You have successfully left #{@group.title}."
    return redirect_to groups_path
  end

  def invite
    # Parse email list and dispatch invitation emails
    group = Group.find_by_gid(params[:id])

    if inv_params = params[:invitations]
      inv_params.values.each do |params|
        email = params[:recipient_email]

        unless group.users.map(&:email).include?(email)
          Invitation.create(group: group, sender: current_user, recipient_email: email)
        end
      end
    end

    flash[:success] = "Invitations sent!"
    return redirect_to expenses_path
  end

  before_filter :find_invitation, only: [:invitations]
  def invitations
    # Join by token

    if request.get? && signed_in?
      # Complete automatically if already signed in, else render the form
      return complete_invitation(user: current_user, group: @group, invitation: @invitation)
    elsif request.post?
      if create_or_authenticate_user(params[:full_name], params[:password])
        login_user(@user)
        return complete_invitation(user: @user, group: @group, invitation: @invitation)
      else
        flash[:error] = "Error - please check your fields and try again."
        return render :invitations
      end
    end
  end

  private

  def user_must_be_in_group
    @group     = Group.find_by_gid(params[:id])
    authorized = @group.present? && @group.users.include?(current_user)
    reject_unauthorized(authorized)
  end

  def find_invitation
    @invitation = Invitation.find_by_token(params[:token])
    return reject_unauthorized if @invitation.blank? || @invitation.invalid?
    @group = @invitation.group
    @user  = User.find_by_email(@invitation.recipient_email)
  end

  def create_or_authenticate_user(name, password)
    if @user.present?
      # Log in
      @user.authenticate(password)
    else
      # Sign up
      @user = User.new(email: @invitation.recipient_email) do |u|
        u.full_name = name
        u.password  = password
      end
      return @user.save
    end
  end

  def complete_invitation(options={})
    user  = options[:user]
    group = options[:group]
    inv   = options[:invitation]

    if group.add_user(user)
      inv.mark_used
      flash[:success] = "You are now a member of #{group.title}!"
      return redirect_to groups_path
    else
      flash.now[:error] = "You already belong to that group!"
      return render :join
    end
  end

  def add_user(group, user)
    if group.add_user(current_user)
      flash[:success] = "You are now a member of #{group.title}!"
      return redirect_to groups_path
    else
      flash.now[:error] = "You already belong to that group!"
      return render :join
    end
  end

end
