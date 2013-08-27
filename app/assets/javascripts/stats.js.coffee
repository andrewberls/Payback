interval = timeout = -1

setLoadingText = ->
  $('.stats-container').html """
    <div class="span-8 offset-4 stats-loading">
        <p>We're crunching numbers - hang tight! </p>
    </div>
  """

addProgress = ->
  $('.stats-loading').find('p').append('.')

fail = ->
  clearInterval(interval)
  clearTimeout(timeout)
  $('.stats-loading').html('Something went wrong :( Try again?')

loadStats = ->
  setLoadingText()
  interval = setInterval(addProgress, 175)
  timeout  = setTimeout(fail, 5000)
  gid      = $('.stats-group-select select').find('option:selected').val()
  $.ajax {
    url: '/stats',
    data: { gid: gid }
    success: (html) ->
      clearTimeout(timeout)
      setTimeout ->
        clearInterval(interval)
        $('.stats-container').html(html)
      , 1000
    error: -> setTimeout(fail, 1000)
  }

$ ->
  loadStats()
  $groups = $('.stats-group-select select')
  $groups.change -> loadStats() # Select from dropdown
