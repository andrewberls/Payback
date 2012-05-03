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
    $form = $(this).parent()    
    $fields = $form.find('input')    
    $fields.each ->
      $parent = $(this).parent()
      if !$(this).val()
        $parent.addClass("error")
        errors = true
      else
        $parent.removeClass("error")
    return false if errors


#------------------------------
# Login
#------------------------------
$ ->
  # Create and insert an alet error box if blank fields present

  $('#submit-login').click ->
    $form = $(this).parent()
    $email = $("#email")
    $password = $("#password")
    errors = validate([$email, $password])
    
    if errors && $form.find('.alert').size() == 0 # Only if an alert doesn't already exist
      alertBox = document.createElement("div")
      alertBox.setAttribute('class', 'alert alert-error');
      errTxt = document.createTextNode("Invalid email or password")
      alertBox.appendChild(errTxt)
      $title = $form.find('.form-title')[0]
      insertAfter($title, alertBox)
      $('.alert').hide().slideDown('fast')
      return false