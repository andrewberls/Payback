class GroupsController < ApplicationController

	before_filter :check_auth, :accept => [:new, :edit, :join]

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
			redirect_to group_path(@group.gid)
		else
			flash[:error] = "Something went wrong - please check your fields and try again."
			#redirect_to new_group_path
			render :new
		end
	end


	#------------------------------
  # READ
  #------------------------------
  def index
  	@groups = current_user.groups
  end

	def show
		@group = Group.find_by_gid(params[:id])
		if !@group
			redirect_to groups_path
		end
	end


	#------------------------------
  # UPDATE
  #------------------------------
	def edit
		@group = Group.find_by_gid(params[:id])
		#redirect_to group_path unless current_user == @group.owner
	end

	def update
		#raise params.inspect
		@group = Group.find_by_gid(params[:id])
   
    if @group.update_attributes(params[:group])
    	flash[:success] = "Group successfully updated."
      redirect_to groups_path      
    else
    	flash[:error] = "Something went wrong - please check your fields and try again."
      render :edit
    end
	end


	#------------------------------
  # DELETE
  #------------------------------
	def destroy		
		# Destroy group and expenses, but preserve users
    #Group.find_by_gid(params[:gid]).destroy
    flash[:success] = "Group successfully deleted"
    redirect_to groups_path
	end


	#------------------------------
  # JOIN
  #------------------------------
	def join
		# View	
	end

	def add
		# Processing
		group = Group.find_by_gid(params[:gid])

		if group && group.authenticate(params[:password])
			if group.users.include? current_user
				flash.now[:error] = "You already belong to that group!"
				render :join
			else
				group.users << current_user
				flash.now[:error] = "success! ignore the error"
				render :join
			end
		else
			flash.now[:error] = "Invalid ID/Password combination."
			render :join
		end
	end

end
