# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  expense_id  :integer
#  creditor_id :integer
#  debtor_id   :integer
#  title       :string(255)
#  amount      :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Payment < ActiveRecord::Base

  NET_TITLE = 'Paying off net total owed'

  attr_accessible :title, :amount, :creditor_id, :debtor_id

  # Money is sent from the debtor to the creditor
  belongs_to :creditor, class_name: 'User'
  belongs_to :debtor,   class_name: 'User'

  # A Payment can potentially encapsulate many expenses (for example,
  # when paying off a net total)
  has_and_belongs_to_many :expenses

  validates_presence_of :creditor_id, :debtor_id, :title, :amount

  after_create :send_notification

  private

  def send_notification
    Notification.create! do |n|
      n.notif_type   = Notification::PAYMENT
      n.expenses << self.expenses
      n.user_from_id = self.debtor_id
      n.user_to_id   = self.creditor_id
    end
  end
end
