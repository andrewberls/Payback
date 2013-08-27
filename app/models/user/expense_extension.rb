module User::ExpenseExtension

  def active_credits
    credits.where(active: true)
  end

  def active_debts
    debts.where(active: true)
  end


  def credits_to(user, attrs={})
    credits.where({ debtor_id: user }.merge(attrs)).order('id DESC')
  end

  def debts_to(user, attrs={})
    debts.where({ creditor_id: user }.merge(attrs)).order('id DESC')
  end


  def active_credits_to(user)
    credits_to(user, active: true)
  end

  def active_debts_to(user)
    debts_to(user, active: true)
  end


  # Total amount loaned within a group (all time)
  def total_credit_amt(group)
    sum_amounts credits.where(group_id: group)
  end

  # Total amount borrowed within a group (all time)
  def total_debt_amt(group)
    sum_amounts debts.where(group_id: group)
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


  # Groups in which this user has outstanding credits
  def groups_with_credits
    groups.reject { |group| group.active_credits_for(self).blank? }
  end

  # Groups in which this user has outstanding debts
  def groups_with_debts
    groups.reject { |group| group.active_debts_for(self).blank? }
  end


  def tagged_credits(tag)
    active_credits.order('id DESC').select { |e| e.has_tag?(tag) }
  end

  def tagged_debts(tag)
    active_debts.order('id DESC').select { |e| e.has_tag?(tag) }
  end


  # User that this user has lent the most money to (all time)
  def credit_leader(group)
    leader(group, :credits)
  end

  # User that this user has borrowed the most from (all time)
  def debt_leader(group)
    leader(group, :debts)
  end


  # Average amount of time it takes this user to be paid back
  def average_credit_lifespan(group)
    average_lifespan(credits, group)
  end

  # Average amount of time it takes this user to pay people back
  def average_debt_lifespan(group)
    average_lifespan(debts, group)
  end

  private

  def sum_amounts(expenses)
    expenses.reduce(0.0) { |total, e| total + e.amount }
  end

  # Internal: find the user with the most accumulated debts
  # or credits to this user.
  #
  #   type: Symbol, either `:credits` or `:debts`
  #
  # Returns has with keys { :name, :amount }
  def leader(group, type)
    amt  = -1
    name = ''

    group.users.reject { |u| u == self }.each do |user|
      exps = (type == :debts) ? debts_to(user) : credits_to(user)

      sum = sum_amounts(exps)
      if sum > amt
        amt  = sum
        name = user.first_name
      end
    end

    { name: name, amount: amt }
  end

  def average_lifespan(expenses, group)
    lifespans = expenses.where(group_id: group).map(&:lifespan).compact
    return unless lifespans.present?

    (lifespans.sum / lifespans.length).round(3)
  end
end
