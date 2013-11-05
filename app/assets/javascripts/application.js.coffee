#= require jquery
#= require jquery_ujs
#= require jquery.easing.1.3
#= require jquery.mailcheck.min
#= require jquery.tipsy
#= require jquery.cookie
#= require jquery.simplemodal.1.4.4.min
#= require bootstrap.tab
#= require laconic
#= require d3.v3.min
#= require validation.min
#
#= require static
#= require expenses/mark_off
#= require expenses/notifications
#= require payments

window.Payback = {}

# Utils
#
# Return a string m/d/y timestamp, ex: 11/3/13
Payback.getTimestamp = ->
  d = new Date()
  month = d.getMonth() + 1
  day   = d.getDate()
  year  = d.getFullYear().toString().slice(2)

  "#{month}/#{day}/#{year}"


window.toggleSlide = ($selector, speed=350) ->
  if $selector.is(':hidden')
    $selector.slideDown(speed)
  else
    $selector.slideUp(speed)


# Enable field validation on blur
ValidateJS.enableActiveChecking = true


$ ->
  # Set up tooltips
  $('[data-tipsy]').tipsy()


  # Dashboard alerts
  $('.close-alert').click ->
    $alert = $(@).parent()
    key    = $alert.data('key')
    $.cookie("closed-#{key}", '1', { expires: 15 })
    $alert.slideUp 400 , -> $alert.parent().parent().remove()


  # Mobile stacked nav
  $userLinks = $('.user-links')
  $navStack  = $('.nav-stack')

  $('.nav-stack-toggle').click ->
    wasToggled = $(@).hasClass('toggled')
    $(@).toggleClass('toggled')
    if wasToggled
      $userLinks.hide()
      $navStack.slideUp()
    else
      $userLinks.show()
      $navStack.slideDown()
    return false
