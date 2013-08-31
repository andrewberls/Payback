progressInterval = -1
failTimeout      = -1

setLoadingText = ->
  $('.stats-container').html """
    <div class="span-8 offset-4 stats-banner">
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
  initUserLoanBorrow()
  initCreditSegments()
  initDebtSegments()


# TODO: de-dup this code

# Initialize loaning/borrowing bar chart
initUserLoanBorrow = ->
  $.getJSON '/stats/type_proportions', gid: currentGid(),
    (json) -> Payback.Charts.drawUserLoanBorrow(json.stats)


# Initialize loaning pie chart
initCreditSegments = ->
  $.getJSON '/stats/segments', gid: currentGid(), type: 'credits',
    (json) -> Payback.Charts.drawCreditSegments(json.stats)


# Initialize loaning pie chart
initDebtSegments = ->
  $.getJSON '/stats/segments', gid: currentGid(), type: 'debts',
    (json) -> Payback.Charts.drawDebtSegments(json.stats)



$ ->
  loadStats()
  $('.stats-group-select select').change -> loadStats() # Select from dropdown
