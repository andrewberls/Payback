class PaymentsController < ApplicationController

  before_filter :must_be_logged_in, except: [:cash]

  def create
    payment_params = params[:payment]

    Payment.create!(payment_params)
    @exp_id = payment_params[:expense_id]

    respond_to do |format|
      format.js
    end
  end

  def index
    @payments_sent     = current_user.payments_sent
    @payments_received = current_user.payments_received
  end
end
