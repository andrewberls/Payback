class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create

    # @EXPENSE = EXPENSE.NEW PARAMS EXPENSE IS AN INSTANCE VARIABLE!
    # RENDER JUST RENDERS A TEMPLATE IN THE CONTEXT OF THIS ACTION
    # SO /EXPENSE/CREATE
    # AND SINCE ITS A FORM FOR @EXPENSE, THE VALID VALUES GET PREFILLED!
    # BUT THE URL CHANGE SUCKS - TRY REDIRECT_TO NEW AND HAVE NEW ACCEPT
    # OPTIONAL @EXPENSE PARAMS?

    @expense = Expense.new(params[:expense].except(:hsplit, :hpayback))

    if @expense.valid?

      @action = determine_action()

      @group = current_user.groups.first # TODO: SHOULD BE ABLE TO SELECT GROUP

      # TODO: selected_users = [...]

      # Set expense associations
      @expense.creditor = current_user
      @expense.group = @group

      # Select users to calculate cost splitting
      if @action == :split
        users = @group.users # Split - all group users        
      else
        users = @group.users - [current_user] # Payback - all group users except the current user
      end

      cost_per_user = (@expense.amount / users.count)
      @expense.amount = cost_per_user

      # TODO: SELECTED USERS, NOT GROUP BY DEFAULT
      @debtors = @group.users - [current_user] # @debtors = selected_users

      @debtors.each do |user|
        # TODO: Check if existing expense to this creditor already and combine?
        user.debts << @expense
      end

    else
      flash[:error] = "Something went wrong - please check your fields and try again"
      return redirect_to new_expense_path
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

  private

  #------------------------------
  # Helper methods for Create
  #------------------------------
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
