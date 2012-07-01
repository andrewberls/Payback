class ExpensesController < ApplicationController

  before_filter :must_be_logged_in

  before_filter :redirect_empty_groups, only: [:new, :index]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @expense = Expense.new
  end

  def create

    # TODO: This controller action is bad and you should feel bad.

    @expense = Expense.new(params[:expense].except(:type))

    if @expense.valid?

      # TODO: No way to log expense type after its created. Should type somehow be made
      # into a field on the expense?


      # 1) Determine the action type
      # 2) Find the selected users
      # 3) Calculate the cost per user depending on the action
      # 4) Set nonchanging expense attrs (group, creditor, amt,..)
      # 5) Clone the expense for each of the debtors

      action = params[:expense][:type] == 'payback' ? :payback : :split

      group = Group.find_by_gid(params[:group][:gid])

      selected_users = []

      if params[:users]
        # Have any users been checked?
        params[:users].keys.each { |id| selected_users << User.find(id) }
      else
        # Otherwise just use the group
        selected_users = group.users - [current_user]
      end

      if selected_users.count == 0
        flash[:error] = "Unable to add expense. Invite more people to your group to start sharing!"
        return redirect_to new_expense_path
      end

      cost_per_user = if action == :split
                        # Split - selected including current
                        @expense.amount / (selected_users+[current_user]).count
                      else
                        # Payback - selected excluding current
                        @expense.amount / selected_users.count
                      end

      cost_per_user = "%.2f" % ((cost_per_user*2.0).round / 2.0) # Round to nearest $0.50
      
      @expense.group    = group
      @expense.creditor = current_user
      @expense.amount   = cost_per_user

      @expense.assign_to selected_users

      return redirect_to expenses_path
    else
      @groups = current_user.groups
      flash.now[:error] = "Error -  check your fields and try again!"
      return render :new
    end
    
  end


  #------------------------------
  # READ
  #------------------------------
  def index
    # Main dashboard
    @credit_groups = current_user.groups_with_credits
    @debt_groups   = current_user.groups_with_debts
  end

  #def condensed
  #end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
    puts "destroy being called in the controller"
    Expense.find_by_id(params[:id]).update_attributes(active: false)
    # TODO: AJAX slide remove instead of flash
    flash[:success] = "Expense successfully completed!"
    return redirect_to expenses_path    
  end

  private

  def redirect_empty_groups
    # Redirect to welcome page if user groups empty
    @groups = current_user.groups
    return redirect_to welcome_path if @groups.blank?
  end
    
end
