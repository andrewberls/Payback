class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create
  end


  #------------------------------
  # READ
  #------------------------------
  def index
    # Main dashboard
    @credits = current_user.credits
    @debts = current_user.debts    
  end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
  end
    
end
