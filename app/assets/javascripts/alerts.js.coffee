$ ->
  $('.close-alert').click ->
    $alert = $(@).parent()
    $alert.fadeOut 350, ->
      $alert.destroy
