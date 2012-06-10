class StaticController < ApplicationController

  layout :choose_layout

  def start
    #redirect_to expenses_path if signed_in?
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
