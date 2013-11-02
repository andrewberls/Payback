class PaymentsController < ApplicationController

  before_filter :must_be_logged_in, except: [:cash]

  def create
    payment_params = params[:payment]

    # TODO: dear god
    @expense_ids = payment_params.delete(:expense_ids).split(',').map(&:to_i)
    Payment.create!(payment_params) do |payment|
      @expense_ids.each { |id| payment.expenses << Expense.find(id) }
    end

    respond_to do |format|
      format.js
    end
  end

  def index
    @payments_sent     = current_user.payments_sent
    @payments_received = current_user.payments_received
  end

end
