loadUsers = ->
  gid     = $('#group-select').find("option:selected").val()
  $column = $(".user-column")

  $.ajax {
    url: "/groups/#{gid}.json?others=true",
    success: (json) ->
      $column.empty()
      for user in json.users
        input = $.el.input {
          "type" : "checkbox",
          "name" : "users[#{user.id}]"
        }
        first_name = user.full_name.split(" ")[0]
        label      = $.el.label(first_name)
        $column.append $.el.userbox(input, label)
  }

$ ->
  speed         = 350
  $groups       = $('#group-select')
  $container    = $('#users-container')
  $group        = $('#users-group')
  $select       = $('#users-select')
  disabledClass = 'btn-disabled2'

  $.el.registerTag 'userbox', (one, two) ->
    # Register a DOM element for user checkbox/labels
    @.appendChild(one)
    @.appendChild(two)

  loadUsers()                   # Initialization
  $groups.change -> loadUsers() # Select from dropdown

  # Slide select up/down and change button display
  $group.click ->
    $container.slideUp(speed)
    $(@).addClass(disabledClass)
    $select.removeClass(disabledClass)
    return false

  $select.click ->
    $container.slideDown(speed)
    $(@).addClass(disabledClass)
    $group.removeClass(disabledClass)
    return false
