$ ->
  $('.group-member-count').click ->
    $names = $(@).parent().find('.group-member-names')
    toggleSlide($names)
    return false
