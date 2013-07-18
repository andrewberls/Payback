module User::ExpenseExtension
  def active_credits
    credits.where(active: true)
  end

  def active_debts
    debts.where(active: true)
  end

  def active_credits_to(user)
    active_credits.where(debtor_id: user).order('id DESC')
  end

  def active_debts_to(user)
    active_debts.where(creditor_id: user).order('id DESC')
  end

  def active_credit_amt_to(user)
    sum_amounts active_credits_to(user)
  end

  def active_debt_amt_to(user)
    sum_amounts active_debts_to(user)
  end

  def total_credit_owed
    sum_amounts active_credits
  end

  def total_debt_owed
    sum_amounts active_debts
  end

  def groups_with_credits
    # Groups in which this user has outstanding credits
    groups.reject { |group| group.active_credits_for(self).blank? }
  end

  def groups_with_debts
    # Groups in which this user has outstanding debts
    groups.reject { |group| group.active_debts_for(self).blank? }
  end

  def sum_amounts(expenses)
    expenses.reduce(0.0) { |total, e| total + e.amount }
  end
end
