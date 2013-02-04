# TODO: factor out all the hard-coded stuff

confirm_btns = (exp_id, debtor_id) ->
  debtor_param = if debtor_id? then "?debtor_id=#{debtor_id}" else ""
  """
    <p>
      <a href="/expenses/#{exp_id}#{debtor_param}" data-method="delete" data-remote="true"
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
    debtor_id = $expense.data('debtor-id')
    $(@).parent().html confirm_btns(exp_id, debtor_id)
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
