$ ->
  speed = 350

  # Select users slide
  #-------------------
  $container    = $('#users-container')
  $group        = $('#users-group')
  $select       = $('#users-select')
  disabledClass = 'disabled'

  $group.click ->
    $container.slideUp(speed)
    $(@).addClass(disabledClass)
    $select.removeClass(disabledClass)
    return false

  $select.click ->
    $container.slideDown(speed)
    $(@).addClass(disabledClass)
    $group.removeClass(disabledClass)
    return false

  # Split/Payback FAQ slide
  #-------------------
  $faq = $('#expense-faqs')

  $('#show-expense-faqs, #hide-expense-faqs').click ->
    if $faq.is(":hidden")
      $faq.slideDown(speed)
    else
      $faq.slideUp(speed)
    return false
