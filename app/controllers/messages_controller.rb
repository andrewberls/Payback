class MessagesController < ApplicationController

  before_filter do |controller|
    must_be_logged_in unless controller.request.format.js?
  end

  def index
    @group = Group.find_by_gid(params[:gid])
  end

  def new
    @message = {
      user: current_user,
      date: Time.now,
      text: params[:text]
    }

    respond_to do |format|
      format.html { return redirect_to messages_path(params[:gid]) }
      format.js
      format.json { render json: @message }
    end

    # id = $redis.get "notes:counter"
    # $redis.hmset "notes:#{id}",
    #              :date, Time.now.to_i,
    #              :text, params[:text],
    #              :user_id, current_user.id,
    #              :gid, params[:gid]
    # $redis.incr "notes:counter"
  end

end
