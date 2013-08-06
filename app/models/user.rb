class User < ActiveRecord::Base

  attr_accessible :full_name, :email, :password, :password_confirmation, :communication_preference

  has_secure_password

  has_and_belongs_to_many :groups
  has_many :owned, class_name: 'Group', foreign_key: :owner_id

  has_many :debts,   class_name: 'Expense', foreign_key: :debtor_id
  has_many :credits, class_name: 'Expense', foreign_key: :creditor_id

  has_many :notifications_from, class_name: 'Notification', foreign_key: 'user_from_id'
  has_many :notifications_to,   class_name: 'Notification', foreign_key: 'user_to_id'

  has_one :communication_preference
  accepts_nested_attributes_for :communication_preference

  validates :full_name, presence: true, length: { maximum: 50 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: valid_email_regex },
    uniqueness: { case_sensitive: false }

  validates :password, presence: { on: :create },
                       length: { minimum: 5 }, :if => :password_digest_changed?

  before_create :generate_auth_token
  after_create :generate_communication_preference

  include User::ExpenseExtension

  def owns?(group)
    group.owner_id == self.id
  end

  def first_name
    @first_name ||= full_name.split(" ").first
  end

  def last_name
    @last_name ||= full_name.split(" ").last
  end

  def expenses(group=nil)
    # All expenses, not just active
    expenses = debts + credits
    return (group.present?) ? expenses.select { |e| e.group == group } : expenses
  end

  def brand_new?
    # This could be smarter. Meh.
    expenses.blank?
  end

  def add_debt(expense)
    expense.debtor = self
    debts << expense
    if receive_communication?(Notification::NEW_DEBT)
      NotificationsMailer.new_debt(expense).deliver
    end
  end

  def unread_notifications
    notifications_to.select(&:unread?)
  end

  def can_notify_on?(exp_id)
    notifications_from.none? { |e| e.expense_id == exp_id }
  end

  def recent_notifications
    notifications_to.order('id DESC').limit(5)
  end

  def update_communication_preferences(prefs)
    communication_preference.update_attributes(prefs)
    communication_preference.touch
  end

  def receive_communication?(type)
    # Preferences are stored as ints rather than booleans
    # to play nicely with Rails checkboxes
    !!communication_preference.send(type).nonzero?
  end

  def expire_reset_tokens
    # Expire all reset tokens for this user
    ResetToken.where(user_id: self.id).each(&:mark_used)
  end

  def generate_reset_token
    # Expire any existing reset tokens and generate a new one
    expire_reset_tokens
    ResetToken.create(user: self)
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def generate_communication_preference
    CommunicationPreference.create!(user: self)
  end

end
