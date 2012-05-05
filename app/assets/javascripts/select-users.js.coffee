loadUsers = (gid) ->
  console.log "loadUsers called with gid: #{gid}"
  $.ajax {
    url: "/groups/#{gid}.json",
    success: (json) ->
      result = ""
      for user in json.users
        result += "
          <label class='checkbox-inline'>
            <input type='checkbox' value='#{user.id}'>
            #{user.first_name}
          </label>
        "
      $(".user-column").html(result)
    error: ->
      # handle error
  }

$ ->

  speed = 350
  $groups    = $('#group-select')
  $container = $('#users-container')
  $group     = $('#users-group')
  $select    = $('#users-select')

  gid = $groups.find("option:selected").val()
  loadUsers(gid)

  $groups.change ->
    gid = $(this).find("option:selected").val()
    loadUsers(gid)

  $group.click ->
    $container.slideUp(speed)
    $(this).addClass('disabled')
    $select.removeClass('disabled')
    return false

  $select.click ->
    $container.slideDown(speed)
    $(this).addClass('disabled')
    $group.removeClass('disabled')
    return false