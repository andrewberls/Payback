module NotificationsHelper

  def notif_text(notif)
    user_span = content_tag :span, notif.user_from.first_name, class: 'user-from'

    if notif.notif_type == Notification::PAYMENT
      raw "#{user_span} sent payment for #{notif.expense_title}"
    else
      raw "#{user_span} requested that you mark off #{notif.expense_title}"
    end
  end

  # Receive email when <...>
  def preference_text(notif_type)
    case notif_type
    when Notification::MARKOFF
      'Someone asks me to mark off an expense'
    when Notification::NEW_DEBT
      'Someone assigns an expense to me'
    end
  end

end
