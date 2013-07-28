$ ->
  errClass = 'field-error'

  # Prevent form submissions if any fields are blank
  $('.form-validate').submit ->
    errors = false

    for field in $(@).find('input[type=text],input[type=email],input[type=password], textarea')
      $(field).removeClass(errClass)
      data = $(field).data('validate')
      shouldValidate = if data? then data else true
      if !$(field).val() && shouldValidate
        $(field).addClass(errClass)
        errors = true

    return !errors

  # Remove the error class if we add a valid value
  $(document).on 'keyup', '.field-error', ->
    $(@).removeClass(errClass) if $(@).val()

  # Perform basic type sanity checking
  $(document).on 'blur', "[data-validate-numeric='true']", ->
    val = $(@).val()
    $(@).addClass(errClass) if isNaN parseInt(val)
