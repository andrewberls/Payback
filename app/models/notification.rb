class Notification < ActiveRecord::Base

  MARKOFF  = 'mark_off'
  NEW_DEBT = 'new_debt'
  VALID_TYPES = [
    MARKOFF,
    NEW_DEBT
  ]

  attr_accessible :user_from_id, :user_to_id, :expense_id, :notif_type, :read

  belongs_to :expense
  belongs_to :user_from, class_name: 'User'
  belongs_to :user_to,   class_name: 'User'

  validates_inclusion_of :notif_type, :in => VALID_TYPES, :message => "Type is not valid"

  def unread?
    !read
  end

  def mark_as_read!
    update_attributes! read: true
  end

  def expense_title
    expense.try(:title) || ''
  end

  def deliver_mail
    case notif_type
    when Notification::MARKOFF
        NotificationsMailer.mark_off(self.expense).deliver
    end
  end

end
