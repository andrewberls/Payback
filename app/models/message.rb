class Message
  attr_accessor :date, :text, :username, :gid

  def initialize(params)
    @text     = params[:text]
    @username = params[:username]
    @date     = params[:date]
    @gid      = params[:gid]
  end

  def save
    # Save all attributes to redis
    counter = $redis.get "counter:#{@gid}" || 0

    $redis.multi do
      $redis.hmset "message:#{@gid}:#{counter}", :text, @text, :date, @date, :username, @username
      $redis.lpush "#{@gid}:lookups", counter
      $redis.incr "counter:#{@gid}"  # Counter for the group
      $redis.incr "messages:counter" # Global counter
    end

  end
end

# Redis key design:
#   counter:gid         -> Message id counter for each group
#   message:gid:counter -> Hash with message attributes for a group identified by counter
#   gid:lookups         -> List of group message ids, for association lookups
#   messages:counter    -> Global message counter
