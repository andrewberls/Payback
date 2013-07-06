$ ->
  errClass = 'field-error'

  # Prevent form submissions if any fields are blank
  $('.form-validate').submit ->
    errors = false

    for field in $(@).find('input[type=text],input[type=email],input[type=password], textarea')
      $(field).removeClass(errClass)
      if !$(field).val()
        $(field).addClass(errClass)
        errors = true

    return !errors

  # Remove the error class if we add a valid value
  $(document).on 'keyup', '.field-error', ->
    $(@).removeClass(errClass) if $(@).val()
