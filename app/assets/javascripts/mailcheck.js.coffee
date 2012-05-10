$email = $('#user_email') 
$email.on 'blur', ->
  $form = $(this).parent()
  $(this).mailcheck {
    suggested: (element, suggestion) ->
      domain = $.el.span({'class' : 'domain'}, "#{suggestion.domain}").outerHTML

      $mail_suggestion = $($.el.span({'class' : 'mail-suggestion', 'style' : 'display: none'}, 
                                      "Yikes! Did you mean #{suggestion.address}@"))

      if $form.find('.mail-suggestion').size() == 0
        #  First error - create/insert a suggestion element
        $mail_suggestion.append "#{domain}?" # Append the domain wrapped in a <span>
        
        $mail_suggestion.click ->
          # Attach a click handler to fill in the suggestion and destroy the node
          $email.val(suggestion.full)
          $(this).fadeOut(150, -> $(this).remove())

        $email.after($mail_suggestion) # Insert the node
        $mail_suggestion.fadeIn(350)   # Fade in the node
      else
        # Subsequent errors - change the existing HTML
        $mail_suggestion.append "#{domain}?"
        $('.mail-suggestion').html($mail_suggestion.html())
  }