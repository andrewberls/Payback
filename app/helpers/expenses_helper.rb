require 'addressable/uri'

module ExpensesHelper

  def blank_expense
    content_tag :div, class: 'expense expense-blank' do
      yield
    end
  end

  def expense_total_for(user)
    "#{user.first_name} owes you #{money(current_user.active_credit_amt_to(user))}"
  end

  def blank_debts
    blank_expense do
      content_tag :p, "You don't owe anybody money! :-)"
    end
  end

  def blank_credits(name=nil)
    owe_str = name.present? ? "#{name} doesn't owe you any money" : "Nobody owes you money"
    blank_expense do
      content_tag :p, raw("#{owe_str}! Click #{ link_to 'here', new_expense_path }
        to add a new expense.")
    end

  end

  def mark_off_btn
    link_to raw("<i class='icon-ok icon-white'></i>"), '#', class: "btn btn-green no-text mark-off-btn"
  end

end
