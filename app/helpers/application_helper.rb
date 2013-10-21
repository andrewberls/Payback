module ApplicationHelper

  def flash_error
    if msg = flash[:error]
      content_tag(:div, msg, class: "alert alert-error")
    end
  end

  def flash_success
    if msg = flash[:success]
      content_tag(:div, msg, class: "alert alert-success")
    end
  end

  # Format a string timestamp, ex: 7 Oct 2011
  def render_date(time)
    time.strftime("%-d %b %Y")
  end

  # Format a string timestamp, ex: 10/7/11
  def render_compact_date(time)
    time.strftime("%-m/%e/%y")
  end

  def money(amount, options = {})
    number_to_currency(amount, options)
  end

end
