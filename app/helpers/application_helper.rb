module ApplicationHelper

  def flash_error
    content_tag(:div, flash[:error], class: "alert alert-error") if flash[:error]
  end

  def flash_success
    content_tag(:div, flash[:success], class: "alert alert-success") if flash[:success]
  end

  def render_date(time)
    # Returns a string timestamp
    # Ex: 7 Oct 2011
    time.strftime("%-d %b %Y")
  end

end
