class NotificationsController < ApplicationController

  def read
    current_user.notifications_to.map &:mark_as_read!
    respond_to do |format|
      format.html { redirect_to expenses_path }
      format.json { render json: {} }
    end
  end

end
