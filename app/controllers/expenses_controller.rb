class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  def new
  end

  def create
  end

  def destroy
  end

  def index
    # Main dashboard
  end
    
end
