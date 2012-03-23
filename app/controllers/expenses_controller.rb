class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create

    @expense = Expense.new(params[:expense].except(:type))

    if @expense.valid?

      action = params[:expense][:type] == 'payback' ? :payback : :split
      group = current_user.groups.first           # TODO: SHOULD BE ABLE TO SELECT GROUP
      selected_users = group.users-[current_user] # TODO: SHOULD BE ABLE TO SELECT USERS

      cost_per_user = if action == :split      
                        @expense.amount / (selected_users+[current_user]).count # Split - selected including current                     
                      else
                        @expense.amount / selected_users.count # Payback - selected excluding current                      
                      end

      @expense.group    = group
      @expense.creditor = current_user
      @expense.amount   = cost_per_user

      selected_users.each do |user|
        # TODO: Check if existing expense to this creditor already and combine?
        expense = @expense.dup
        expense.debtor = user
        current_user.credits << expense
      end

    else      
      flash.now[:error] = "Error -  check your fields and try again"
      return render :new
    end 
        
    return redirect_to expenses_path

  end


  #------------------------------
  # READ
  #------------------------------
  def index
    # Main dashboard
    @credits = current_user.credits.order("id DESC")
    @debts = current_user.debts.order("id DESC")
  end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
    Expense.find_by_id(params[:id]).destroy
    flash[:success] = "Expense successfully removed."
    redirect_to expenses_path    
  end
    
end
