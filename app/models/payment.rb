class Payment < ActiveRecord::Base
  attr_accessible :title, :amount, :expense_id, :creditor_id, :debtor_id

  # Money is sent from the debtor to the creditor
  belongs_to :creditor, class_name: 'User'
  belongs_to :debtor,   class_name: 'User'

  belongs_to :expense

  validates_presence_of :expense_id, :creditor_id, :debtor_id

  after_create :send_notification

  private

  def send_notification
    Notification.create! do |c|
      c.notif_type   = Notification::PAYMENT
      c.expense_id   = self.expense_id
      c.user_from_id = self.debtor_id
      c.user_to_id   = self.creditor_id
    end
  end
end
