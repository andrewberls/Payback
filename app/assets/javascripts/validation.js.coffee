# Insert one DOM node after another
insertAfter = (refNode, newNode) ->
  refNode.parentNode.insertBefore(newNode, refNode.nextSibling)

# Serialized array of all user-facing input fields in a form
inputFields = ($form) ->
  $form.find('input:not([type=submit]):visible, textarea').serializeArray()

validate = (fields) ->
  for field in fields
    return true if !field.value
  return false

# Create and insert an alert error box if blank fields present
# Only if an alert doesn't already exist
# Custom error messages can be specified using the data-failure attribute:
#   <%= link_to "Text, path, data: { failure: 'You dun goofed' } %>
rejectBlank = ($form, message) ->

  errors = validate inputFields($form)
  message ||= "Error - Please check your fields and try again!"

  if errors && $form.find('.alert').size() == 0
    alertBox = $.el.div { 'class':'alert alert-error' }, message
    $title   = $form.find('.form-title')[0]
    insertAfter($title, alertBox)
    $('.alert').hide().slideDown('fast')
    return false

$ ->
  $('.submit-validate').click ->
    rejectBlank $(@).parent(), $(@).data('failure')
