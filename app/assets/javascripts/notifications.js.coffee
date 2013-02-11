confirm_btns = (exp_id) ->
  """
    <p>
      <a href="/expenses/#{exp_id}" data-method="delete" data-remote="true"
        rel="nofollow" class="confirm-yes">yes</a> /
      <a href='#' class="confirm-no">no</a>
    </p>
  """

$ ->
  $doc      = $(document)
  $dropdown = $('.notifications-container')
  $notif    = $('.notification')
  $trigger  = $('.dropdown-trigger')
  $badge    = $('header .badge')

  $trigger.click ->
    $dropdown.show 'fast', 'linear', ->
      $badge.remove()
      $doc.on 'click', ->
        $dropdown.hide()
        $notif.removeClass('notification-unread')
        $doc.unbind('click')

    $.post "/notifications/read"


  $(document.body).delegate '.mark-off-btn', 'click', ->
    $expense  = $(@).parent().parent()
    exp_id    = $expense.data('id')
    $(@).parent().html confirm_btns(exp_id)
    return false

  $(document.body).delegate '.confirm-yes', 'click', ->
    $actions = $(@).parent().parent()
    exp_id   = $actions.parent().data('id')
    $expense = $('*[data-id="' + exp_id + '"]')
    $actions.remove()
    $expense.slideUp -> $expense.remove()

  $(document.body).delegate '.confirm-no', 'click', ->
    $(@).parent().parent().html """
      <a href="#" class="btn no-text btn-green mark-off-btn">
        <i class='icon-ok icon-white'></i>
      </a>
    """
    return false
