class NotificationsController < ApplicationController

  def create
    notif_params = params[:notification]
    @exp_id = notif_params.delete(:expense_id)
    notification = Notification.new(notif_params) do |n|
      n.expenses << Expense.find(@exp_id)
    end

    if notification.save!
      notification.deliver_mail
    end

    respond_to do |format|
      format.js
    end
  end

  def read
    current_user.notifications_to.map &:mark_as_read!
    return render nothing: true
  end

end
