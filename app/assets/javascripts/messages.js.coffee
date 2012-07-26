$ ->
  # Initial load of existing group messages

  $messages = $("#messages")
  gid = window.location.pathname.slice(10) # :-(

  $.ajax {
    url: "/groups/#{gid}/messages.json",
    success: (messages) ->
      for json in messages
        $messages.append "
          <div class='message'>
            <p class='message-user'>#{json.username}</p>
            <p class='message-date'>#{json.date}</p>
            <p class='message-text'>#{json.text}</p>
          </div>
        "
  }

