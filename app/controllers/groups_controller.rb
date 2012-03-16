class GroupsController < ApplicationController

	before_filter :check_auth, :accept => [:new, :edit, :join]

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(params[:group])
		@group.initialize_owner(current_user)
		if @group.save
			redirect_to expenses_path
		else
			flash.now[:error] = "Could not create your group - please check your fields and try again."
			render :new
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def join
		# View	
	end

	def add
		# Processing
		@group = Group.find_by_gid(params[:gid])
			if !@group
				flash.now[:error] = "Invalid ID/Password combination."
				render :join
			else
				# Group found - check password
			end
	end

end
