require 'expression_parser'

class ExpensesController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :redirect_empty_groups, only: [:new, :index]
  before_filter :must_own_expense,      only: [:edit, :update, :destroy]

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(params[:expense]) do |exp|
      exp.action = (params[:commit] == 'Payback') ? :payback : :split
      exp.amount = ExpressionParser.parse(params[:expense][:amount])
    end

    if @expense.valid?
      group          = Group.find_by_gid(params[:group][:gid])
      selected_users = User.users_from_keys(params[:users], group, current_user)

      if selected_users.empty?
        flash[:error] = "Unable to add expense. Invite more people to your group to start sharing!"
        return redirect_to new_expense_path
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
      @groups = current_user.groups
      flash.now[:error] = "Error - check your fields and try again!"
      return render :new
    end

  end


  before_filter :find_dashboard_resources, only: [:index, :condensed]

  def index
    # Main dashboard
    @notice = SiteNotice.last

    respond_to do |format|
      format.html
      format.js
    end
  end

  def condensed
    # Dashboard - one listing per group user
    respond_to do |format|
      format.js
    end
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
    respond_to do |format|
      format.html { return redirect_to params[:redirect] || expenses_path }
      format.json { return render json: {} }
    end
  end

  def clear
    # Mark all expenses to a user completed
    user     = User.find(params[:id])
    expenses = current_user.active_credits_to(user)
    expenses.map(&:deactivate)
    return redirect_to expenses_path
  end

  private

  def redirect_empty_groups
    # Redirect to welcome page if user groups empty
    @groups = current_user.groups
    return redirect_to welcome_path if @groups.blank?
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

end
