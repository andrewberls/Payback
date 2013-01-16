$ ->
  $('.close-alert').click ->
    $alert = $(@).parent()
    key    = $alert.data('key')
    $.cookie("closed-#{key}", '1', { expires: 15 });
    $alert.fadeOut 350, -> $alert.parent().parent().remove()
