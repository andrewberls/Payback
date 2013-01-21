//= require jquery
//= require jquery_ujs
//= require jquery.easing.1.3
//= require laconic
//= require jquery.mailcheck.min
//= require jquery.tipsy
//= require jquery.cookie

//= require validation
//= require word_slide
//= require notifications


$ ->
  # Set up tooltips
  $('.expense-stale').tipsy()
  $('.expense-edited').tipsy()
  $('.mark-off-notification').tipsy()

  # Dashboard alerts
  $('.close-alert').click ->
    $alert = $(@).parent()
    key    = $alert.data('key')
    $.cookie("closed-#{key}", '1', { expires: 15 });
    $alert.slideUp 400 , -> $alert.parent().parent().remove()
