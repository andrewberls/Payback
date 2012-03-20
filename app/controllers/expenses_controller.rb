class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create

    @action = determine_action()

    @expense = Expense.new(params[:expense].except(:hsplit, :hpayback)) 
    @expense.creditor = current_user    
    
    # TODO: SHOULD BE ABLE TO SELECT GROUP
    @group = current_user.groups.first    

    if @action == :split
      # Split - all group users
      @users = @group.users
    else
      # Payback - all group users except the current user
      @users = @group.users - [current_user]      
    end
    
    if @expense.amount == 0 or @expense.amount.blank?
      flash[:error] = "Invalid amount"
      return redirect_to new_expense_path
    else
      cost_per_user = (@expense.amount / @users.count)
      @expense.amount = cost_per_user
    end

    @users = @group.users - [current_user]

    @users.each do |user|
      user.debts << @expense
    end

    raise @users.first.debts.inspect

    # For each user selected
      # Register a new expense for $cost_per_user with current_user as the creditor
        # user.add_debt(creditor, expense)
    # End

     

    raise "END OF METHOD REACHED" 

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

  private

  def determine_action
    # For expense creation - determine the action type based on hidden field parameters

    if params[:expense][:hsplit] == '-1' && params[:expense][:hpayback] == '-1'
      # Split by default if hidden type fields retained default value (if slipped by JS somehow)
      :split
    else 
      return params[:expense][:hsplit] == '1' ? :split : :payback
    end
  end
    
end
