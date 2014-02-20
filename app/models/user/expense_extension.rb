module User::ExpenseExtension

  def active_credits(attrs={})
    credits.where({ active: true }.merge(attrs)).order('id DESC')
  end

  def active_debts(attrs={})
    debts.where({ active: true }.merge(attrs)).order('id DESC')
  end


  def active_credits_to(user)
    active_credits(debtor_id: user.id)
  end

  def active_debts_to(user)
    active_debts(creditor_id: user.id)
  end


  # Total amount loaned within a group (all time)
  def total_credit_amt(group)
    sum_amounts credits.where(group_id: group.id)
  end

  # Total amount borrowed within a group (all time)
  def total_debt_amt(group)
    sum_amounts debts.where(group_id: group.id)
  end

  # Total you've loaned this user
  def total_credit_amt_to(user)
    sum_amounts credits.where(debtor_id: user.id)
  end

  # Total you've borrowed from this user
  def total_debt_amt_to(user)
    sum_amounts debts.where(creditor_id: user.id)
  end

  # How much this user currently owes you
  def active_credit_amt_to(user)
    sum_amounts active_credits_to(user.id)
  end

  # How much you currently owe this user
  def active_debt_amt_to(user)
    sum_amounts active_debts_to(user.id)
  end


  def total_credit_owed
    sum_amounts active_credits
  end

  def total_debt_owed
    sum_amounts active_debts
  end


  # Net totals
  def net_in_debt_to?(user)
    active_debt_amt_to(user) > user.active_debt_amt_to(self)
  end

  # Will return negative num if user is in debt to self
  # Unintended use case.
  def net_owed_to(user)
    active_debt_amt_to(user) - user.active_debt_amt_to(self)
  end


  # Groups in which this user has outstanding credits
  def groups_with_credits
    groups.reject { |group| active_credits.where(group_id: group.id).blank? }
  end

  # Groups in which this user has outstanding debts
  def groups_with_debts
    groups.reject { |group| active_debts.where(group_id: group.id).blank? }
  end


  def tagged_credits(tag)
    active_credits.order('id DESC').select { |e| e.has_tag?(tag) }
  end

  def tagged_debts(tag)
    active_debts.order('id DESC').select { |e| e.has_tag?(tag) }
  end

  private

  def sum_amounts(expenses)
    expenses.map(&:amount).reduce(0, :+)
  end

end
