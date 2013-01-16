module ExpensesHelper

  def blank_expense
    content_tag :div, class: 'expense expense-blank' do
      yield
    end
  end

  def blank_credits
    blank_expense do
      content_tag :p, "You don't owe anybody money! :-)"
    end
  end

  def blank_debts
    blank_expense do
      content_tag :p, raw("Nobody owes you money! Click #{ link_to 'here', new_expense_path }
        to add a new expense.")
    end

  end

  def mark_off_btn(expense)
    return_path = (current_page? expenses_path) ? expenses_path : request.fullpath

    link_to raw("<i class='icon-ok icon-white'></i>"),
      { controller: 'expenses', action: 'destroy', id: expense.id, redirect: return_path },
      :method => :delete, :remote => true,
      confirm: "Mark #{number_to_currency(expense.amount)} from #{expense.debtor.first_name} completed?",
      class: "btn no-text btn-green mark-off-btn"
  end

end
