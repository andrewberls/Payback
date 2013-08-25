$ ->
  $doc      = $(document)
  $dropdown = $('.notifications-container')
  $notif    = $('.notification')
  $trigger  = $('.dropdown-trigger')
  $badge    = $('header .badge')

  $trigger.click ->
    $dropdown.show 'fast', 'linear', ->
      $badge.remove()
      $doc.on 'click', ->
        $dropdown.hide()
        $notif.removeClass('notification-unread')
        $doc.unbind('click')

    $.post '/notifications/read'
