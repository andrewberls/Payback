check_btn = ->
  """
    <a href="#" class="btn no-text btn-green mark-off-btn">
      <i class='icon-ok icon-white'></i>
    </a>
  """

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

  $doc.on 'click', '.mark-off-btn', ->
    $expense  = $(@).parent().parent()
    exp_id    = $expense.data('id')
    $(@).parent().html confirm_btns(exp_id)
    return false

  $doc.on 'click', '.confirm-yes', ->
    $actions = $(@).parent().parent()
    exp_id   = $actions.parent().data('id')
    $expense = $("*[data-id='#{exp_id}']")
    $actions.remove()
    $expense.slideUp ->
      $expense.remove()
      unless $(".notification:not([class~='notification-completed'])").length
        $dropdown.hide()
        $('.notifications-container').hide()

  $doc.on 'click', '.confirm-no', ->
    $(@).parent().parent().html check_btn()
    return false
