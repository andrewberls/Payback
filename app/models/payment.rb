class Payment < ActiveRecord::Base

  NET_TITLE = 'Paying off net total owed'

  attr_accessible :title, :amount, :expense_id, :creditor_id, :debtor_id

  # Money is sent from the debtor to the creditor
  belongs_to :creditor, class_name: 'User'
  belongs_to :debtor,   class_name: 'User'

  belongs_to :expense

  validates_presence_of :creditor_id, :debtor_id, :title, :amount

  after_create :send_notification

  # A payment does not necessarily belong to an expense;
  # it can represent a payment of a net total to someone
  def has_expense?
    expense_id.present?
  end

  private

  def send_notification
    Notification.create! do |c|
      c.notif_type   = Notification::PAYMENT
      c.expense_id   = self.expense_id if has_expense?
      c.user_from_id = self.debtor_id
      c.user_to_id   = self.creditor_id
    end
  end
end
