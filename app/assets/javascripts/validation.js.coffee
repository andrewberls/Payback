#------------------------------
# UTILITIES
#------------------------------
insertAfter = (referenceNode, newNode) ->
  referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling)

validate = (fields) ->
  errors = false
  for field in fields
    errors = true if !field.val()
  errors


#------------------------------
# User creation
# Group creation
# Group join
#------------------------------
$ ->
  # Add red border around blank fields

  $('#submit-validate').click ->    
    errors = false
    $form = $(@).parent()    
    $fields = $form.find('input')

    $fields.each ->
      if !$(@).val()
        $(@).addClass('field-error')
        errors = true
      else
        $(@).removeClass('field-error')

    return false if errors


#------------------------------
# Login
# Add Expense
#------------------------------
$ ->
  # Create and insert an alet error box if blank fields present
  # TODO: only the validation is unique. Refactor alertbox creation

  $('#submit-login').click ->
    $form = $(@).parent()
    $email = $("#email")
    $password = $("#password")
    errors = validate([$email, $password])
    
    if errors && $form.find('.alert').size() == 0 # Only if an alert doesn't already exist
      alertBox = $.el.div({'class':'alert alert-error'}, "Invalid email or password")
      $title = $form.find('.form-title')[0]
      insertAfter($title, alertBox)
      $('.alert').hide().slideDown('fast')
      return false

  $('#expense-payback, #expense-split').click ->
    $form = $(@).parent()
    $amount = $("#expense_amount")
    $title = $("#expense_title")
    errors = validate([$amount, $title])
    
    if errors && $form.find('.alert').size() == 0 # Only if an alert doesn't already exist
      alertBox = $.el.div({'class':'alert alert-error'}, "Please check your fields and try again")
      $title = $form.find('.form-title')[0]
      insertAfter($title, alertBox)
      $('.alert').hide().slideDown('fast')
      return false