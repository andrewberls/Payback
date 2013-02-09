emailField = (num) ->
  """
  <div class="invitation-field">
    <input type="text" name="invitations[#{num}]recipient_email">
    <a href="" class="invitation-remove">&times;</a>
  </div>
  """

$ ->
  $('.show-invitations').click ->
    $groupInvitations = $(@).parent().parent().next('.group-invitations')
    toggleSlide($groupInvitations, 500)


  inv_num = 1
  $form   = $(".group-invitations form")
  $submit = $form.find('.invite-btns')
  $(emailField(inv_num)).insertBefore($submit);

  $(".add-invitation").click ->
    # Slide down new invitations
    $field = $( emailField(++inv_num) ).hide()
    $field.insertBefore($submit).slideDown()

  $(document.body).delegate '.invitation-remove', 'click', ->
    # Slide up and destroy an invitation
    $inv = $(@).parent()
    $inv.slideUp -> $inv.remove()
    return false


