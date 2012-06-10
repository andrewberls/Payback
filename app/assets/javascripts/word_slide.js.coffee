#----- Word slide module ---#
$ ->
  $window = $('#word-scroll-inner')
  numWords = $window.find('.word').size()
  wordHeight = 30
  i = 1

  rotate =  ->
    offset = Math.abs(i - 1)
    distance = wordHeight * offset;

    $window.animate({ top: -distance }, 750, 'easeInQuint', -> 
      if i == numWords
        i = 1
      else
        i++     
    )

  setInterval(rotate, 2250)