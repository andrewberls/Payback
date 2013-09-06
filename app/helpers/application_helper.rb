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

  # Returns a string timestamp, ex: 7 Oct 2011
  def render_date(time)
    time.strftime("%-d %b %Y")
  end

  def money(amount, options = {})
    number_to_currency(amount, options)
  end

end
