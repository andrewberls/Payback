# The flash looks kinda strange if you update your profile multiple times
# Slide it out of the way after a while
setTimeout ->
  $('.edit_user .alert-success').slideUp -> $(@).remove()
, 1000
