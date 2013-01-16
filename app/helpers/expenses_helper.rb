module ExpensesHelper

  def mark_off_btn(expense)
    return_path = (current_page? expenses_path) ? expenses_path : request.fullpath

    link_to raw("<i class='icon-ok icon-white'></i>"),
      { controller: 'expenses', action: 'destroy', id: expense.id, redirect: return_path },
      :method => :delete, :remote => true,
      confirm: "Mark #{number_to_currency(expense.amount)} from #{expense.debtor.first_name} completed?",
      class: "btn no-text btn-green mark-off-btn"
  end

end
