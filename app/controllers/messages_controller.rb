class MessagesController < ApplicationController

  before_filter do |controller|
    must_be_logged_in unless controller.request.format.js?
  end

  def index
    @group = Group.find_by_gid(params[:gid])
  end

  def new
    @message = Message.new(
      username: current_user.full_name,
      date: Time.now,
      text: params[:text],
      gid: params[:gid]
    )

    @message.save
  end

end
