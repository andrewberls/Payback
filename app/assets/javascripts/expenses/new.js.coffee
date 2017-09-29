loadUsers = ->
  gid     = $('#group-select').find("option:selected").val()
  $column = $(".user-column")

  $.ajax {
    url: "/groups/#{gid}.json?exclude_current=true",
    success: (json) ->
      $column.empty()
      for user in json.group.users
        input = $.el.input {
          "type" : "checkbox",
          "name" : "users[#{user.id}]"
        }
        first_name = user.full_name.split(" ")[0]
        label      = $.el.label(first_name)
        $column.append $.el.userbox(input, label)
  }

$ ->
  $.el.registerTag 'userbox', (input, label) ->
    # Register a DOM element for user checkbox/labels
    @.appendChild(input)
    @.appendChild(label)

  loadUsers()
  $('#group-select').change -> loadUsers()
