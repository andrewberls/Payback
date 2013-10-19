$ ->

  # Signup carousel
  $('.landing-main .btn-cta').click ->
    paneWidth = $('.landing-carousel-pane').outerWidth()
    $('.landing-carousel-inner').animate { 'left': "-#{paneWidth}px" }
    return false

  # Word scroll
  $window    = $('#word-scroll-inner')
  numWords   = $window.find('.word').size()
  wordHeight = 30
  i = 1

  rotate =  ->
    offset   = Math.abs(i - 1)
    distance = wordHeight * offset

    $window.animate { top: -distance }, 750, 'easeInQuint', ->
      if i == numWords then i = 1 else i++

  setInterval(rotate, 2250)
