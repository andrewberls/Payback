class NotificationsController < ApplicationController

  def create
    notif_params = params[:notification]
    Notification.create(notif_params)
    @exp_id = notif_params[:expense_id]

    respond_to do |format|
      format.js
    end
  end

  def read
    current_user.notifications_to.map &:mark_as_read!

    respond_to do |format|
      format.html { return redirect_to expenses_path }
      format.json { return render json: {} }
    end
  end

end
