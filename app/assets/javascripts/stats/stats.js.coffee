progressInterval = -1
failTimeout      = -1

setLoadingText = ->
  $('.stats-container').html """
    <div class="stats-banner">
        <p>We're crunching numbers - hang tight! </p>
    </div>
  """


currentGid = ->
  $('.stats-group-select select').find('option:selected').val()


addProgress = ->
  $('.stats-banner').find('p').append('.')


fail = ->
  clearInterval(progressInterval)
  clearTimeout(failTimeout)
  $('.stats-banner').html('Something went wrong :( Try again?')


loadStats = ->
  setLoadingText()
  progressInterval = setInterval(addProgress, 175)
  failTimeout      = setTimeout(fail, 5000)
  $.ajax {
    url: '/stats',
    data: { gid: currentGid() }
    success: (html) ->
      clearTimeout(failTimeout)
      setTimeout ->
        clearInterval(progressInterval)
        $('.stats-container').html(html)
        loadCharts()
      , 1000
    error: -> setTimeout(fail, 1000)
  }


# Page is done loading, kick off chart rendering
loadCharts = ->
  gid = currentGid()
  Payback.Charts.drawUserLoanBorrow(gid)
  Payback.Charts.drawCreditSegments(gid)
  Payback.Charts.drawDebtSegments(gid)



$ ->
  loadStats()
  $('.stats-group-select select').change -> loadStats() # Select from dropdown
