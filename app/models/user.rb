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

  has_many :payments_sent,     class_name: 'Payment', foreign_key: 'debtor_id'
  has_many :payments_received, class_name: 'Payment', foreign_key: 'creditor_id'

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
    @first_name ||= full_name.split(' ').first
  end

  def last_name
    @last_name ||= full_name.split(' ').last
  end

  # All expenses, not just active
  def expenses(group=nil)
    expenses = debts + credits
    return (group.present?) ? expenses.select { |e| e.group == group } : expenses
  end

  # This could be smarter. Meh.
  def brand_new?
    expenses.blank?
  end

  def add_debt(expense)
    expense.debtor = self
    debts << expense
    # TODO: hack to shut up Travis.
    if Rails.env != 'test' && receive_communication?(Notification::NEW_DEBT)
      NotificationsMailer.delay.new_debt(expense.id)
    end
  end

  def unread_notifications
    notifications_to.select(&:unread?)
  end

  def notified_on?(exp_id)
    notifications_from.any? { |n| n.expense_id == exp_id }
  end

  def can_notify_on?(exp_id)
    !notified_on?(exp_id)
  end

  def recent_notifications
    notifs = notifications_to.order('id DESC')
    notifs.any?(&:unread?) ? notifs : notifs.limit(5)
  end

  def update_communication_preferences(prefs)
    communication_preference.update_attributes(prefs)
    communication_preference.touch
  end

  # Preferences are stored as ints rather than booleans
  # to play nicely with Rails checkboxes
  def receive_communication?(type)
    !!communication_preference.send(type).nonzero?
  end

  # Expire all reset tokens for this user
  def expire_reset_tokens
    ResetToken.where(user_id: self.id).each(&:mark_used)
  end

  # Expire any existing reset tokens and generate a new one
  def generate_reset_token
    expire_reset_tokens
    ResetToken.create(user: self)
  end

  # TODO: this needs refactoring
  def sent_payment_for?(expense)
    Payment.includes(:expenses).where(debtor_id: id).any? do |payment|
      payment.expenses.where(id: expense.id).exists?
    end
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def generate_communication_preference
    CommunicationPreference.create!(user: self)
  end

end
