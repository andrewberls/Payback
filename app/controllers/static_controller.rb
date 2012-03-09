class StaticController < ApplicationController

  before_filter :check_auth, :accept => [:welcome]

  def welcome
  	# First time login - belong to no groups.
  end

end
