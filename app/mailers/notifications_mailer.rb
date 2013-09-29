class NotificationsMailer < ApplicationMailer

  def mark_off(expense_id)
    @expense   = Expense.find(expense_id)
    @recipient = @expense.creditor
    @sender    = @expense.debtor
    @group     = @expense.group
    @subject   = "#{@sender.first_name} has asked you to mark off an expense on payback.io"

    mail to: @recipient.email, subject: @subject
  end

  def new_debt(expense_id)
    @expense   = Expense.find(expense_id)
    @recipient = @expense.debtor
    @sender    = @expense.creditor
    @group     = @expense.group
    @subject   = "#{@sender.first_name} has assigned you a debt on payback.io"

    mail to: @recipient.email, subject: @subject
  end

end
