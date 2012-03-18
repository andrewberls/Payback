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
  
  $select.click ->
    $container.slideDown(speed)
    $(this).addClass('disabled')
    $group.removeClass('disabled')

  # Split/Payback FAQ slide
  #-------------------
  $faq = $('#expense-faqs')
  
  $('#show-expense-faqs').click ->
    if $faq.is(":hidden")
        $('#expense-faqs').slideDown(speed)
      else
        $('#expense-faqs').slideUp(speed)

  $('#hide-expense-faqs').click ->  
    $('#expense-faqs').slideUp(350)