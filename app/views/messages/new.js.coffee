$messages = $("#messages")

$messages.append "
  <div class='message'>
    <p class='message-user'><%= @message.username %></p>
    <p class='message-date'><%= render_date @message.date %></p>
    <p class='message-text'><%= @message.text %></p>
  </div>
"

$messages.animate {
  scrollTop: $messages.prop("scrollHeight")
}, 250

$("#new-message").val('')
