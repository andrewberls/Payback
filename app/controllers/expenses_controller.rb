class ExpensesController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :redirect_empty_groups, only: [:new, :index]
  before_filter :must_own_expense,      only: [:edit, :update, :destroy]

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.build(params)

    if @expense.valid?
      group          = Group.find_by_gid(params[:group][:gid])
      selected_users = safe_for_group(params[:users], group)

      if selected_users.blank?
        flash[:error] = "Unable to add expense. Invite more people to your group to start sharing!"
        return render :new
      end

      cost_per_user = @expense.cost_for(selected_users)
      @expense.tap do |exp|
        exp.group    = group
        exp.creditor = current_user
        exp.amount   = cost_per_user
        exp.assign_to selected_users
      end

      return redirect_to expenses_path
    else
      flash.now[:error] = "Error - check your fields and try again!"
      return render :new
    end
  end


  before_filter :find_dashboard_resources, only: [:index]

  def index
    # Main dashboard
    respond_to do |format|
      format.html
      format.js
      format.json { return render json: current_user.expenses }
    end
  end

  def tagged
    @tag     = params[:tag]
    @credits = current_user.tagged_credits(@tag)
    @debts   = current_user.tagged_debts(@tag)
  end

  def show
    # TODO: find the cause for this
    redirect_to expenses_path
  end

  def edit
  end

  def update
    if @expense.update_attributes(params[:expense])
      flash[:success] = "Expense successfully updated."
      return redirect_to expenses_path
    else
      flash.now[:error] = "Something went wrong - please check your fields and try again."
      return render :edit
    end
  end


  def destroy
    @expense.deactivate
    @credit_owed = current_user.total_credit_owed
    @user = @expense.debtor

    if request.xhr?
      return render json: {}
    else
      return redirect_to params[:redirect] || expenses_path
    end
  end

  def clear
    # Mark all credits to a user completed
    debtor   = User.find(params[:id])
    expenses = current_user.active_credits_to(debtor)
    expenses.map(&:deactivate)
    return redirect_to expenses_path
  end

  private

  def redirect_empty_groups
    return redirect_to new_group_path if current_user.groups.blank?
  end

  def find_dashboard_resources
    @credit_groups = current_user.groups_with_credits
    @debt_groups   = current_user.groups_with_debts
  end

  private

  def must_own_expense
    @expense   = Expense.find(params[:id])
    authorized = current_user.active_credits.include?(@expense)
    reject_unauthorized(authorized)
  end

  # Filter selected input to users actually belonging to group
  def safe_for_group(users, group)
    group_users    = group.users
    selected_users = []

    if users
      # Have any users been checked?
      users.keys.each do |id|
        user = User.find_by_id(id)
        selected_users << user if group_users.include?(user)
      end
    else
      # Otherwise just use the whole group
      selected_users = group_users - [current_user]
    end

    selected_users
  end

end
