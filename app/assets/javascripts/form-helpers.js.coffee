$ ->

  #------------------------------
  # Add Expense
  #------------------------------

  speed = 350

  # Select users slide
  #-------------------
  $container = $('#users-container')
  $group = $('#users-group')
  $select = $('#users-select')

  $group.click ->
    $container.slideUp(speed)
    $(this).addClass('disabled')
    $select.removeClass('disabled')
    return false
  
  $select.click ->
    $container.slideDown(speed)
    $(this).addClass('disabled')
    $group.removeClass('disabled')
    return false

  # Split/Payback FAQ slide
  #-------------------
  $faq = $('#expense-faqs')
  
  $('#show-expense-faqs').click ->
    if $faq.is(":hidden")
        $('#expense-faqs').slideDown(speed)
      else
        $('#expense-faqs').slideUp(speed)
    return false

  $('#hide-expense-faqs').click ->  
    $('#expense-faqs').slideUp(350)
    return false

  # Submit button handling
  #-------------------
  $hsplit = $('#expense_hsplit')     # Hidden field
  $hpayback = $('#expense_hpayback') # Hidden field

  $('#expense-split').click ->
    $hsplit.val('1')
    $hpayback.val('0')

  $('#expense-payback').click ->
    $hsplit.val('0')
    $hpayback.val('1')
