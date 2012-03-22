class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create

    @expense = Expense.new(params[:expense].except(:hsplit, :hpayback))

    if @expense.valid?

      action = params[:expense][:hpayback] == '1' ? :payback : :split
      group = current_user.groups.first           # TODO: SHOULD BE ABLE TO SELECT GROUP
      selected_users = group.users-[current_user] # TODO: SHOULD BE ABLE TO SELECT USERS

      cost_per_user = if action == :split      
                        @expense.amount / group.users.count # Split - all group users                        
                      else
                        @expense.amount / selected_users.count # Payback - all group users except the current user                        
                      end

      @expense.group    = group
      @expense.creditor = current_user
      @expense.amount   = cost_per_user        

      selected_users.each do |user|
        # TODO: Check if existing expense to this creditor already and combine?
        user.debts << @expense
      end

    else      
      flash.now[:error] = "Error -  check your fields and try again"
      #return redirect_to new_expense_path
      return render :new
    end 
        
    return redirect_to expenses_path

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
    @expense = Expense.find_by_id(params[:id])

    if @expense.destroy
      flash[:success] = "Expense successfully removed."
      redirect_to expenses_path
    else
      flash.now = "Something went wrong - please try again."
      render :index
    end
  end
    
end
