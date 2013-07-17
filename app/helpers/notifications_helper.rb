module NotificationsHelper

  def notif_text(notif)
    user_span = content_tag :span, notif.user_from.first_name, class: 'user-from'
    raw "#{user_span} requested that you mark off #{notif.expense_title}"
  end

  # Receive email when <...>
  def preference_text(notif_type)
    case notif_type
    when Notification::MARKOFF
      'A user asks me to mark off an expense'
    end
  end

end
