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


  def self.users_from_keys(users, group, creditor)
    group_users    = group.users
    selected_users = []

    if users
      # Have any users been checked?
      users.keys.each do |id|
        user = User.find_by_id(id)
        selected_users << user if group_users.include?(user)
      end
    else
      # Otherwise just use the whole group
      selected_users = group_users - [creditor]
    end

    selected_users
  end

  def owns?(group)
    group.owner == self
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

  def active_credits
    credits.where(active: true)
  end

  def active_debts
    debts.where(active: true)
  end

  def active_credits_to(user)
    active_credits.where(debtor_id: user).order('id DESC')
  end

  def active_debts_to(user)
    active_debts.where(creditor_id: user).order('id DESC')
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

  def groups_with_credits
    # Groups in which this user has outstanding credits
    groups.reject { |group| group.active_credits_for(self).blank? }
  end

  def groups_with_debts
    # Groups in which this user has outstanding debts
    groups.reject { |group| group.active_debts_for(self).blank? }
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
  end

  def receive_communication?(type)
    # Preferences are stored as integer strings rather than booleans
    # to play nicely with Rails checkboxes
    !!communication_preference.send(type).to_i.nonzero?
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

  def sum_amounts(expenses)
    expenses.reduce(0.0) { |total, e| total + e.amount }
  end

end
