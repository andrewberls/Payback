fade = ($node) ->
  # The classic yellow fade, taken from Douglas Crockford
  level = 7
  step = ->
    hex = level.toString(16)
    $node.css('background-color', '#FFFF' + hex + hex)
    if (level < 15)
      level += 1
      setTimeout(step, 85)

  step()


$messages = $("#messages")

$messages.append "
  <div class='message'>
    <p class='message-user'><%= @message.username %></p>
    <p class='message-date'><%= @message.date %></p>
    <p class='message-text'><%= @message.text %></p>
  </div>
"
fade $("#messages .message:last-of-type")

$messages.animate {
  scrollTop: $messages.prop("scrollHeight")
}, 250

$("#new-message").val('')
