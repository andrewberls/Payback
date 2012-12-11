$ ->
  $name = $("#field-name")

  $("#existing").click ->
    $title = $(@).parent().parent().find('.form-title')

    if $(@).prop('checked')
      $name.slideUp()
      $title.html("Log in")
    else
      $name.slideDown()
      $title.html("Sign up")
