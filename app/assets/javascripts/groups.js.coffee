$ ->
  speed = 350
  $toggle = $('.group-member-count')

  $toggle.click ->
    $names = $(@).parent().find('.group-member-names')
    if $names.is(':visible')
      $names.slideUp(speed)
    else
      $names.slideDown(speed)

    return false