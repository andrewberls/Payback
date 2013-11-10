# Cache of searchable words (loaded at DOM ready)
expenseWords = {}


# Parse expense DOM elements into their searchable words
# (tags, titles, person)
# Returns hash of { id -> [words] }
parseSearchableWords = ->
  $('.expenses-container [data-expense-id]').each (_, el) ->
    key = $(@).data('expense-id')
    expenseWords[key] ||= []
    title  = $.trim($(@).find('.expense-title').text()).split(' ')
    person = $(@).find('.expense-person').text()
    tags   = $(@).find('.tag').map( (_, el) -> $(el).text() ).get()
    expenseWords[key] = expenseWords[key].concat(title, person, tags)

  for key, words of expenseWords
    expenseWords[key] = expenseWords[key].map (word) ->
      word.toLowerCase()

  expenseWords


# Determine matches against all expenses for an input query
#
#   input - array of words entered by the user
#
# Returns hash of { id -> Boolean }
matchesFor = (inputWords) ->
  matches = {}
  for id, bodyWords of expenseWords
    matches[id] = inputMatch(bodyWords, inputWords)
  matches


# Determime if an expense's searchable text matches an input query
# All words in the input query must match (or substring match) the
# expense's body words
#
#   bodyWords  - Array of an expense's searchable words to match against
#   inputWords - Array of words entered by the user
#
# Returns Boolean
inputMatch = (bodyWords, inputWords) ->
  numMatches = 0
  for inputWord in inputWords
    for bodyWord in bodyWords
      if bodyWord.indexOf(inputWord) == 0
        numMatches++
        break

  return numMatches == inputWords.length


# Add link to clear input field
addCloseLink = ->
  $container = $('.expense-filter-container')
  if $container.find('.icon-remove').length == 0
    $('.expense-filter-container').append """
      <i class="icon-remove"></i>
    """

# Remove clear link and show all expenses
showAll = ->
  $('.expense-filter-container .icon-remove').remove()
  $('.expense').show()


# Show/hide DOM elements based on pre-determined
# match against input query
#
#   expenseMatches - hash of { id -> Boolean }
#
# Returns nothing
filterExpenses = (input) ->
  for id, matches of matchesFor(input)
    $exp = $("[data-expense-id=#{id}]")
    if matches then $exp.show() else $exp.hide()



$ ->
  expenseWords = parseSearchableWords()
  $input = $('.expense-filter-container input')

  $input.keyup ->
    input = $(@).val()
                .split(' ')
                .map (word) -> word.toLowerCase()

    if input[0] != ''
      addCloseLink()
      filterExpenses(input)
    else
      showAll()

  $(document).on 'click', '.expense-filter-container .icon-remove', ->
    $input.val('')
    showAll()

