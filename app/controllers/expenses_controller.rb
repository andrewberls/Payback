class ExpensesController < ApplicationController

  before_filter :check_auth, :accept => [:index, :new]

  #------------------------------
  # CREATE
  #------------------------------
  def new
    @groups = current_user.groups
    @expense = Expense.new
  end

  def create

    # This entire method needs to be revamped. I feel like a lot of this could be put into helper methods

    @expense = Expense.new(params[:expense].except(:type))

    if @expense.valid?

      action = params[:expense][:type] == 'payback' ? :payback : :split

      group = Group.find_by_gid(params[:group][:gid])

      selected_users = []

      if params[:users]
        # Have any users been checked?
        params[:users].keys.each { |id| selected_users << User.find_by_id(id) }
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

      # TODO: user.microposts.build(content: "Lorem ipsum")
      
      @expense.group    = group
      @expense.creditor = current_user
      @expense.amount   = cost_per_user
      @expense.assign_to selected_users

    else
      @groups = current_user.groups
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
    @groups = current_user.groups
    @credits = current_user.active_credits.order("id DESC")
    @debts = current_user.active_debts.order("id DESC")
  end


  #------------------------------
  # DELETE
  #------------------------------
  def destroy
    Expense.find_by_id(params[:id]).update_attributes(active: false)
    flash[:success] = "Expense successfully removed."
    redirect_to expenses_path    
  end
    
end
