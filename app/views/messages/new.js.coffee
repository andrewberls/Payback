faye = new Faye.Client("<%= FAYE_DOMAIN %>/faye")
$messages = $("#messages")

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


  # Likely an error with capture in broadcast() here
  # This appears to short circuit and not send anything
  # $messages.append str

<% broadcast "/group/#{@message.gid}/messages" do %>
  $("#messages").append("<div class='message'>
      <p class='message-user'><%= @message.username %></p>
      <p class='message-date'><%= @message.date %></p>
      <p class='message-text'><%= @message.text %></p>
    </div>");
<% end %>


fade $("#messages .message:last-of-type")

$messages.animate { scrollTop: $messages.prop("scrollHeight") }, 250

$("#new-message").val('')
