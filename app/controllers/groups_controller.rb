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
	end

	def update
	end


	#------------------------------
  # DELETE
  #------------------------------
	def destroy
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
