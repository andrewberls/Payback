class User < ActiveRecord::Base

  attr_accessible :full_name, :email, :password, :password_confirmation

  has_secure_password

  has_and_belongs_to_many :groups
  has_many :owned, class_name: 'Group', :foreign_key => :owner_id

  has_many :debts,   class_name: 'Expense', :foreign_key => :debtor_id
  has_many :credits, class_name: 'Expense', :foreign_key => :creditor_id

  has_many :notifications_from, class_name: 'Notification', :foreign_key => 'user_from_id'
  has_many :notifications_to,   class_name: 'Notification', :foreign_key => 'user_to_id'


  validates :full_name,
    presence: true,
    length: { maximum: 50 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: valid_email_regex },
    uniqueness: { case_sensitive: false }

  validates :password, presence: { on: :create },
                       length: { minimum: 5 }, :if => :password_digest_changed?

  before_create :generate_auth_token


  def self.users_from_keys(users, group, current_user)
    # TODO: current_user parameter is a hack as its only accessible through controllers.
    selected_users = []

    if users
      # Have any users been checked?
      users.keys.each do |id|
        user = User.find_by_id(id)
        selected_users << user if group.users.include?(user)
      end
    else
      # Otherwise just use the whole group
      selected_users = group.users - [current_user]
    end

    selected_users
  end

  def as_json(options={})
    options[:except] = [:password_digest, :auth_token, :updated_at]
    super(options)
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
  end

  def active_credits
    credits.where(active: true)
  end

  def active_debts
    debts.where(active: true)
  end

  def active_credits_to(user)
    credits.where(debtor_id: user, active: true).order('id DESC')
  end

  def active_debts_to(user)
    debts.where(creditor_id: user, active: true).order('id DESC')
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
    notifications_to.reverse.take(5)
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def sum_amounts(expenses)
    expenses.map(&:amount).inject(&:+) || 0
  end

end
