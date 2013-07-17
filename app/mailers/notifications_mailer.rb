class NotificationsMailer < ActionMailer::Base
  default from: "noreply.paybackio@gmail.com"

  def mark_off(expense)
    @expense   = expense
    @recipient = @expense.creditor
    @sender    = @expense.debtor
    @group     = @expense.group

    mail to: @recipient.email, subject: "#{@sender.first_name} has asked you to mark off an expense on payback.io"
  end

end
