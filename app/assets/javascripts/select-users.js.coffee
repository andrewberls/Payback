loadUsers = (gid) ->
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
        first_name = user.full_name.split(" ")[0]
        label = $.el.label({}, "#{first_name}")
        $column.append $.el.userbox(input, label)
  }

$ ->

  speed = 350
  $groups    = $('#group-select')
  $container = $('#users-container')
  $group     = $('#users-group')
  $select    = $('#users-select')
  disabledClass = 'btn-disabled2';

  $.el.registerTag 'userbox', (one, two) ->
    # Register a laconic element for user rendering
    this.appendChild(one)
    this.appendChild(two)

  # TODO: I don't like the repetition for init and subsequent changes. Can this be combined?
  gid = $groups.find("option:selected").val()
  loadUsers(gid)

  $groups.change ->
    gid = $(this).find("option:selected").val()
    loadUsers(gid)

  # Slide select up/down and change button display
  $group.click ->
    $container.slideUp(speed)
    $(this).addClass(disabledClass)
    $select.removeClass(disabledClass)
    return false

  $select.click ->
    $container.slideDown(speed)
    $(this).addClass(disabledClass)
    $group.removeClass(disabledClass)
    return false