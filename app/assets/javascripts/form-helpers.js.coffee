$ ->

	#------------------------------
	# Add Expense
	#------------------------------

	# Select users slide
	

	# Split/Payback FAQ slide
	$faq = $('#expense-faqs')
	speed = 350

	$('#show-expense-faqs').click ->
		if $faq.is(":hidden")
	      $('#expense-faqs').slideDown(speed)
	    else
	      $('#expense-faqs').slideUp(speed)

  $('#hide-expense-faqs').click ->  
    $('#expense-faqs').slideUp(350)