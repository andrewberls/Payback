$ ->

  # The `.cash-btn` opens a mailto link for Square Cash.
  # We use a hidden form to POST data to the Payback backend
  # beforehand so we can maintain internal data
  $('.cash-btn').click ->
    $(@).parent().submit()


  $('.nav-tabs a').click ->
    $(@).tab('show')
    return false
