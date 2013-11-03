class NotificationsController < ApplicationController

  def create
    notif_params = params[:notification]
    if notification = Notification.create(notif_params)
      notification.deliver_mail
    end
    @exp_id = notif_params[:expense_id]

    respond_to do |format|
      format.js
    end
  end

  def read
    current_user.notifications_to.map &:mark_as_read!
    return render nothing: true
  end

end
