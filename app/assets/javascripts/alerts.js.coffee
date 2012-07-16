# $ ->
#   $('.close-alert').click ->
#     $.cookie('closed_alert', '1', { expires: 365 });
#     $alert = $(@).parent()
#     $alert.fadeOut 350, ->
#       $alert.destroy
