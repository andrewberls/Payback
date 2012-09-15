$ ->
  speed   = 350
  $toggle = $('.group-member-count')

  $toggle.click ->
    $names = $(@).parent().find('.group-member-names')
    if $names.is(':hidden')
      $names.slideDown(speed)
    else
      $names.slideUp(speed)

    return false
