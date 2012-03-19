module ApplicationHelper

  def render_date(time)    
    # Returns a string timestamp
    # Ex: 7 Oct 2011
    time.strftime("%-d %b %Y")
  end

end
