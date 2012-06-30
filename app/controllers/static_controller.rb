class StaticController < ApplicationController

  layout :choose_layout

  #before_filter :must_be_logged_in, only: [:contact, :mail]

  def start
    redirect_to expenses_path if signed_in?
  end

  def contact
    @message = Message.new
  end

  def mail
    @message = Message.new(params[:message])
    
    if @message.valid?      
      Notifier.new_message(@message).deliver
      flash[:success] = "Thanks! We'll get back to you as soon as possible." 
      return redirect_to contact_path
    else
      flash[:error] = "Please check your fields and try again!"
      return redirect_to contact_path
    end
  end

  def not_found
  end

  private

  def choose_layout
    if ['start'].include? action_name
      'static'
    else
      'application'
    end
  end

end
