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

  def render_date(time)
    # Returns a string timestamp
    # Ex: 7 Oct 2011
    time.strftime("%-d %b %Y")
  end

  def money(amount, options = {})
    number_to_currency(amount, options)
  end

end
