class GroupsController < ApplicationController

	before_filter :check_auth, :accept => [:new, :edit, :join]

	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def join
	end

end
