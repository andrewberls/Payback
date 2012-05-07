loadUsers = (gid) ->

  $.el.registerTag 'userbox', (one, two) ->
    this.appendChild(one)
    this.appendChild(two)

  console.log "loadUsers called with gid: #{gid}"
  $.ajax {
    url: "/groups/#{gid}.json?others=true",
    success: (json) ->
      $column = $(".user-column")
      $column.html("")
      for user in json.users
        input = $.el.input {
          "type" : "checkbox",
          "name" : "users[#{user.id}]"
        }
        label = $.el.label({}, "#{user.first_name}")
        $column.append $.el.userbox(input, label)
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