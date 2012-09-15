#------------------------------
# UTILITIES
#------------------------------
insertAfter = (refNode, newNode) ->
  refNode.parentNode.insertBefore(newNode, refNode.nextSibling)

inputFields = ($form) ->
  # Serialized array of all user-facing input fields in a form
  $form.find('input:not([type=submit]):visible').serializeArray()

validate = (fields) ->
  errors = false
  for field in fields
    errors = true if !field.value
  errors

rejectBlank = ($form, message) ->
  # Create and insert an alert error box if blank fields present
  # Only if an alert doesn't already exist

  errors = validate inputFields($form)
  message ||= "Error - Please check your fields and try again!"

  if errors && $form.find('.alert').size() == 0
    alertBox = $.el.div({'class':'alert alert-error'}, message)
    $title   = $form.find('.form-title')[0]
    insertAfter($title, alertBox)
    $('.alert').hide().slideDown('fast')
    return false

$ ->
  $('#submit-validate').click ->
    rejectBlank $(@).parent()

  $('#submit-login').click ->
    rejectBlank $(@).parent(), "Invalid email or password"
