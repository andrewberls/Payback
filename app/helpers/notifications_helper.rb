module NotificationsHelper

  # Receive email when <...>
  def preference_text(notif_type)
    case notif_type
    when Notification::MARKOFF
      'Someone asks me to mark off an expense'
    when Notification::NEW_DEBT
      'Someone assigns an expense to me'
    end
  end

  def notif_unread_class(notification)
    notification.unread? ? 'notification-unread' : ''
  end

end
