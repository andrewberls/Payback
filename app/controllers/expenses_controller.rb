class ExpensesController < ApplicationController

  before_filter :check_auth

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @groups = current_user.groups
    @expense = Expense.new

    return redirect_to welcome_path if @groups.blank?
  end

  def create

    # TODO: This controller action is bad and you should feel bad.

    @expense = Expense.new(params[:expense].except(:type))

    if @expense.valid?

      # TODO: No way to log expense type after its created. Should type somehow be made
      # into a field on the expense?

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
    @groups = current_user.groups
  end

  #def condensed
  #end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
    Expense.find_by_id(params[:id]).update_attributes(active: false)
    # TODO: AJAX slide remove instead of flash
    flash[:success] = "Expense successfully completed!"
    return redirect_to expenses_path    
  end
    
end
