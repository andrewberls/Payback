# require 'net/http'
# require 'uri'

module ApplicationHelper

  def render_date(time)
    # Returns a string timestamp
    # Ex: 7 Oct 2011
    time.strftime("%-d %b %Y")
  end

  def action_request
    # Returns a formatted string of the requested controller/action pair
    # Ex "users#manage"
    params[:controller] + "#" + params[:action]
  end

  def broadcast(channel, &block)
    data = capture(&block)
    puts "CHANNEL:\n#{channel.to_json}"
    puts "DATA:\n#{data.to_json}"
    puts "FAYE_DOMAIN:\n#{FAYE_DOMAIN}/faye"

    message = { channel: channel, data: data }
    uri = URI.parse("#{FAYE_DOMAIN}/faye")
    Net::HTTP.post_form(uri, message: message.to_json)
  end

end
