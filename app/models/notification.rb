class Notification < ActiveRecord::Base

  VALID_STATES = %w( mark_off )

  attr_accessible :user_from_id, :user_to_id, :expense_id, :notif_type, :read

  belongs_to :expense
  belongs_to :user_from, class_name: 'User'
  belongs_to :user_to,   class_name: 'User'

  validates_inclusion_of :notif_type, :in => VALID_STATES, :message => "Type is not valid"

  def unread?
    !read
  end

  def mark_as_read!
    update_attributes! read: true
  end

end
