class StaticController < ApplicationController

  layout :choose_layout

  #before_filter :must_be_logged_in, only: [:contact, :mail]

  def start
    redirect_to expenses_path if signed_in?
  end

  def contact
    @feedback = Feedback.new
  end

  def mail
    @feedback = Feedback.new(params[:feedback])

    if @feedback.valid?
      Notifier.new_message(@feedback).deliver
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
