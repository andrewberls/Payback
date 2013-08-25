#= require jquery
#= require jquery_ujs
#= require jquery.easing.1.3
#= require laconic
#= require jquery.mailcheck.min
#= require jquery.tipsy
#= require jquery.cookie
#= require jquery.simplemodal.1.4.4.min

#= require validation
#= require word_slide
#= require expenses/mark_off
#= require expenses/notifications

$ ->

  # Utils
  window.toggleSlide = ($selector, speed=350) ->
    if $selector.is(':hidden')
      $selector.slideDown(speed)
    else
      $selector.slideUp(speed)

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

  # Show mailer modal only on dashboard, hackety hack
  modal = $("#mailer-modal")
  if modal.length
    modal.modal()

  $(document).on 'click', '.simplemodal-close', ->
    $.cookie('closed_mailer_modal', '1', { expires: 15 })
