module NotificationsHelper

  def notif_text(notif)
    user_span = content_tag :span, notif.user_from.first_name, class: 'user-from'
    raw "#{user_span} requested that you mark off #{notif.expense.title}"
  end

end
