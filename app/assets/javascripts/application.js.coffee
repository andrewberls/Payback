#= require jquery
#= require jquery_ujs
#= require jquery.easing.1.3
#= require jquery.mailcheck.min
#= require jquery.tipsy
#= require jquery.cookie
#= require jquery.simplemodal.1.4.4.min
#= require laconic
#= require d3.v3.min
#= require validation.min
#
#= require word_slide
#= require expenses/mark_off
#= require expenses/notifications

window.Payback = {}

# Utils
window.toggleSlide = ($selector, speed=350) ->
  if $selector.is(':hidden')
    $selector.slideDown(speed)
  else
    $selector.slideUp(speed)


# Enable field validation on blur
ValidateJS.enableActiveChecking = true


$ ->
  # Set up tooltips
  $('.expense-stale').tipsy()
  $('.expense-edited').tipsy()
  $('.mark-off-notification').tipsy()

  # Dashboard alerts
  $('.close-alert').click ->
    $alert = $(@).parent()
    key    = $alert.data('key')
    $.cookie("closed-#{key}", '1', { expires: 15 })
    $alert.slideUp 400 , -> $alert.parent().parent().remove()
