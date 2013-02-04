class NotificationsController < ApplicationController

  def create
    Notification.create(params[:notification])
    return redirect_to expenses_path
  end

  def read
    current_user.notifications_to.map &:mark_as_read!

    respond_to do |format|
      format.html { return redirect_to expenses_path }
      format.json { return render json: {} }
    end
  end

end
