class Message
  attr_accessor :date, :text, :username, :gid

  def initialize(params)
    @text = params[:text]
    @username = params[:username]
    @date = params[:date]
    @gid = params[:gid]
  end

  def save
    # Save all attributes to redis
    counter = $redis.get "counter:#{@gid}" || 0

    $redis.multi do
      $redis.hmset "message:#{@gid}:#{counter}", :text, @text, :date, @date.to_i, :username, @username
      # set gid:lookup -> [counter1, counter2] : then find msgs with message:gid:counter
      $redis.lpush "#{@gid}:lookups", counter
      $redis.incr "counter:#{@gid}"
    end

  end
end
