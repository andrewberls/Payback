$email = $('#user_email')
$hint = $("#hint")

$email.on 'blur', ->

  $(this).mailcheck {
    suggested: (elem, suggestion) ->
      if !$hint.html()
        # First error - fill in/show entire hint element
        suggestion = "Yikes! Did you mean <span class='suggestion'>#{suggestion.address}@<a href='#' class='domain'>#{suggestion.domain}</a></span>?"
        $hint.html(suggestion).fadeIn(150)
      else
        # Subsequent errors - modify domain only
        $(".domain").html "#{suggestion.domain}"
  }

$(document.body).delegate '.domain', 'click', ->
  # On click, fill in the field with the suggestion and remove the hint
  $email.val $(".suggestion").text()
  $hint.fadeOut(200, -> $(this).empty())