$ ->

  # The `.cash-btn` opens a mailto link for Square Cash.
  # We use a hidden form to POST data to the Payback backend
  # beforehand so we can maintain internal data
  $('.cash-btn').click ->
    $(@).parent().submit()


  # Tabbed nav on /payments dashboard
  $('.nav-tabs a').click ->
    $(@).tab('show')
    return false


  # Pay all button click confirmation on user debt page
  $('.pay-all-btn').click ->
    $(@).replaceWith """<span class="confirm-yes">You're done!</span>"""

  # Expense titles on payment notification
  $('.payment-notification-toggle').click ->
    toggleSlide($('.payment-notification-expenses'))
    return false
