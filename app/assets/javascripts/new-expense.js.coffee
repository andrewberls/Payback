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
  speed           = 350
  $groups         = $('#group-select')
  $container      = $('#users-container')
  $group          = $('#users-group')
  $select         = $('#users-select')
  primaryClass    = 'btn-blue'
  group_btn_text  = "Group Expense"
  users_btn_text  = "Select Users &raquo;"
  check_icon      = '<i class="icon-white icon-ok"></i>'

  $.el.registerTag 'userbox', (input, label) ->
    # Register a DOM element for user checkbox/labels
    @.appendChild(input)
    @.appendChild(label)

  loadUsers()                   # Initialization
  $groups.change -> loadUsers() # Select from dropdown

  # Slide user select up/down and change button display
  $group.click ->
    $container.slideUp(speed)
    $(@).addClass(primaryClass).html(check_icon + group_btn_text)
    $select.removeClass(primaryClass).html(users_btn_text)
    return false

  $select.click ->
    $container.slideDown(speed)
    $(@).addClass(primaryClass).html(check_icon + users_btn_text)
    $group.removeClass(primaryClass).html(group_btn_text)
    return false

  # Split/Payback FAQ slide
  $faq = $('#expense-faqs')
  $('#show-expense-faqs, #hide-expense-faqs').click ->
    toggleSlide($faq)
    return false
