# Insert one DOM node after another
insertAfter = (refNode, newNode) ->
  refNode.parentNode.insertBefore(newNode, refNode.nextSibling)

# User-facing input fields in a form
inputFields = ($form) ->
  $form.find('input[type=text],input[type=email],input[type=password]')

# Filter blank fields from a list
fieldsWithErrors = (fields) ->
  result = []
  for f in fields
    result.push(f) if !f.value or f.value.length == 0
  result

# Add error classes to fields with errors
rejectBlank = ($form, message) ->
  fields    = inputFields($form)
  errFields = fieldsWithErrors(fields)
  errClass  = 'field-error'

  if errFields.length > 0
    $(fields).removeClass(errClass)
    $(field).addClass(errClass) for field in errFields
    return false

$ ->
  $('.submit-validate').click ->
    rejectBlank $(@).parent()
