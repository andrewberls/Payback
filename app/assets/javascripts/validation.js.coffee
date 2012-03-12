#------------------------------
# UTILITIES
#------------------------------
insertAfter = (referenceNode, newNode) ->
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling)


#------------------------------
# SIGNUP
#------------------------------
$ ->
  $('#submit-signup').click ->
    # Add red border around blank fields
    errors = false
    $form = $(this).parent()
    $fields = $form.find('input')
    $fields.each ->
      $parent = $(this).parent()
      if $(this).val() == ""
        $parent.addClass("error")
        errors = true
      else
        $parent.removeClass("error")
    return false if errors


#------------------------------
# LOGIN
#------------------------------
$ ->
  $('#submit-login').click ->
    # Dynamically create and insert an alet error box if blank fields present
    $form = $(this).parent()
    $email = $("#email")
    $password = $("#password")
    if $email.val() == "" or $password.val() == ""
      if $form.find('.alert').size() == 0 # Only if an alert doesn't already exist
        alertBox = document.createElement("div")
        alertBox.setAttribute('class', 'alert alert-error');
        errTxt = document.createTextNode("Invalid email or password")
        alertBox.appendChild(errTxt)
        $title = $form.find('.form-title')[0]
        insertAfter($title, alertBox)
        $('.alert').hide().slideDown('fast')
      return false