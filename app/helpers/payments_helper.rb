module PaymentsHelper
  # Construct a mailto link for Square Cash with fields properly formatted
  def square_cash_link(expense)
    uri = Addressable::URI.new
    uri.query_values = {
      'Subject' => money(expense.amount),
      'CC'      => 'cash@square.com',
      'Body'    => expense.title # TODO
    }
    href = "mailto:#{expense.creditor.email}?#{uri.query}"
    link_to "$", href, target: '_blank', title: 'Pay with Square Cash', class: 'btn btn-purple no-text no-text-tiny cash-btn'
  end
end
