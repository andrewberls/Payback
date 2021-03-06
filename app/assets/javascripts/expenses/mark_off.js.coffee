checkBtn = ->
  """
    <a href="#" class="btn no-text btn-green mark-off-btn">
      <i class='icon-ok icon-white'></i>
    </a>
  """

confirmBtns = (exp_id) ->
  """
    <p>
      <a href="/expenses/#{exp_id}" data-method="delete" data-remote="true"
        rel="nofollow" class="confirm-yes">yes</a> /
      <a href='#' class="confirm-no">no</a>
    </p>
  """

# Find an expense DOM element given its expense ID
findExpenseById = (exp_id) -> $(".expense[data-expense-id='#{exp_id}']")


markCompleted = ($notif) ->
  $notif.removeClass('notification-unread').addClass('notification-completed')


$ ->
  $doc      = $(document)
  $dropdown = $('.notifications-container')

  # Mark off single request
  $doc.on 'click', '.mark-off-btn', ->
    $expense  = $(@).parent().parent()
    exp_id    = $expense.data('expense-id')
    $(@).parent().html confirmBtns(exp_id)
    return false


  $doc.on 'click', '.notification .confirm-yes', ->
    $btn     = $(@)
    $actions = $btn.parent().parent()
    $notif   = $actions.parent()
    $expense = findExpenseById($notif.data('expense-id'))

    markCompleted($notif)
    $btn.remove()
    $actions.replaceWith("<span class='green-check'></span>")
    $expense.slideUp -> $expense.remove()


  $doc.on 'click', '.expense .confirm-yes', ->
    $btn     = $(@)
    $actions = $btn.parent().parent()
    $expense = $actions.parent()
    $btn.remove()
    $expense.slideUp -> $expense.remove()


  $doc.on 'click', '.confirm-no', ->
    $(@).parent().parent().html checkBtn()
    return false


  # Mark off multiple expenses (payment)
  $doc.on 'click', '.payment-mark-off-btn', ->
    $btn   = $(@)
    $notif = $btn.parent()
    markCompleted($notif)
    $btn.replaceWith("<span class='green-check'></span>")

    # TODO: will be coerced to Number instead of array if only 1
    # id present. This needs serious refactoring.
    exp_ids = $notif.data('expense-ids')
    exp_ids = [exp_ids] if typeof exp_ids == 'number'
    for exp_id in exp_ids
      $.ajax "/expenses/#{exp_id}", { type: 'DELETE' }
      $expense = findExpenseById(exp_id)
      $expense.slideUp -> $expense.remove()

    return false
