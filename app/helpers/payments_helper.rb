module PaymentsHelper

  def cash_email_body(amount, title)
    if title == Payment::NET_TITLE
      "I'm sending you #{money(amount)} through Payback Cash."
    else
      "I'm sending you #{money(amount)} for #{title} through Payback Cash."
    end
  end

  # Construct a mailto link for Square Cash with fields properly formatted
  #
  #
  # payment_opts - Hash expecting the following keys:
  #   :amount
  #   :title
  #   :mailto
  #
  # btn_opts - Optional hash which accepts the following keys:
  #   :class - String CSS class name to add
  #   :value - String button text
  #
  def square_cash_link(payment_opts, btn_opts={})
    amount  = payment_opts[:amount]
    title   = payment_opts[:title]
    mailto  = payment_opts[:mailto]

    uri = Addressable::URI.new
    uri.query_values = {
      'Subject' => money(amount),
      'CC'      => 'cash@square.com',
      'Body'    => cash_email_body(amount, title)
    }

    text  = btn_opts[:value] || '$'
    klass = btn_opts[:class] || ''
    href  = "mailto:#{mailto}?#{uri.query}"
    link_to text, href, target: '_blank', title: 'Pay with Square Cash',
      class: "btn btn-purple cash-btn #{klass}"
  end

end
