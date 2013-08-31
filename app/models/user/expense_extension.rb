module User::ExpenseExtension

  def active_credits(attrs={})
    credits.where({ active: true }.merge(attrs)).order('id DESC')
  end

  def active_debts(attrs={})
    debts.where({ active: true }.merge(attrs)).order('id DESC')
  end


  def active_credits_to(user)
    active_credits(debtor_id: user)
  end

  def active_debts_to(user)
    active_debts(creditor_id: user)
  end


  # Total amount loaned within a group (all time)
  def total_credit_amt(group)
    sum_amounts credits.where(group_id: group)
  end

  # Total amount borrowed within a group (all time)
  def total_debt_amt(group)
    sum_amounts debts.where(group_id: group)
  end

  # Total you've loaned this user
  def total_credit_amt_to(user)
    sum_amounts credits.where(debtor_id: user)
  end

  # Total you've borrowed from this user
  def total_debt_amt_to(user)
    sum_amounts debts.where(creditor_id: user)
  end

  # How much this user currently owes you
  def active_credit_amt_to(user)
    sum_amounts active_credits_to(user)
  end

  # How much you currently owe this user
  def active_debt_amt_to(user)
    sum_amounts active_debts_to(user)
  end


  def total_credit_owed
    sum_amounts active_credits
  end

  def total_debt_owed
    sum_amounts active_debts
  end


  # Groups in which this user has outstanding credits
  def groups_with_credits
    groups.reject { |group| active_credits.where(group_id: group).blank? }
  end

  # Groups in which this user has outstanding debts
  def groups_with_debts
    groups.reject { |group| active_debts.where(group_id: group).blank? }
  end


  def tagged_credits(tag)
    active_credits.order('id DESC').select { |e| e.has_tag?(tag) }
  end

  def tagged_debts(tag)
    active_debts.order('id DESC').select { |e| e.has_tag?(tag) }
  end

  private

  def sum_amounts(expenses)
    expenses.reduce(0.0) { |total, e| total + e.amount }
  end

end
