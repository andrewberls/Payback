$ ->
  $doc      = $(document)
  $dropdown = $('.notifications-container')
  $notif    = $('.notification')
  $trigger  = $('.dropdown-trigger')
  $badge    = $('header .badge')

  $trigger.click ->
    if $dropdown.is(':visible')
      $dropdown.hide()
      $notif.removeClass('notification-unread')
    else
      $dropdown.show 'fast', 'linear', ->
        $badge.remove()

    $.post '/notifications/read'
