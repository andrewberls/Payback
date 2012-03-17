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
			flash[:error] = "Something went wrong - please check your fields and try again."
			#redirect_to new_group_path
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
				flash[:error] = "Invalid ID/Password combination."
				redirect_to join_group_path
			else
				# Group found - check password
			end
	end

end
