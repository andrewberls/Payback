#------------------------------
# SIGNUP
#------------------------------
insertAfter = (referenceNode, newNode) ->
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling)
    
$ ->
  $('#submit-signup').click ->
    $form = $(this).parent()
    $email = $("#email")
    $password = $("#password")
    if $email.val() == "" or $password.val() == ""
      if $form.find('.alert').size() == 0 # if an alert doesn't already exist
        # Dynamically create and insert an alet error box
        alertBox = document.createElement("div")
        alertBox.setAttribute('class', 'alert alert-error');
        errTxt = document.createTextNode("Invalid email or password")
        alertBox.appendChild(errTxt)
        $title = $form.find('.form-title')[0]
        insertAfter($title, alertBox)
        $('.alert').hide().slideDown('fast')
      return false

#------------------------------
# LOGIN
#------------------------------
