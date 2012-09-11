class User < ActiveRecord::Base

  attr_accessible :full_name, :email, :password, :password_confirmation

  has_secure_password

  validates :full_name,
    presence: true,
    length: {maximum: 50}

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: valid_email_regex },
    uniqueness: { case_sensitive: false }

  validates :password, presence: { on: :create },
                       length: { minimum: 5 }, :if => :password_digest_changed?

  before_create :generate_auth_token


  # Groups
  has_and_belongs_to_many :groups
  has_many :owned, class_name: "Group", :foreign_key => :owner_id

  # Expenses
  has_many :debts,   class_name: "Expense", :foreign_key => :debtor_id
  has_many :credits, class_name: "Expense", :foreign_key => :creditor_id


  def self.users_from_keys(users, group, current_user)
    # TODO: current_user parameter is a hack as its only accessible through controllers.
    selected_users = []

    if users
      # Have any users been checked?
      users.keys.each do |id|
        user = User.find(id)
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
    full_name.split(" ").first
  end

  def last_name
    full_name.split(" ").last
  end

  def expenses
    # All expenses, not just active
    debts + credits
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

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def sum_amounts(expenses)
    expenses.map(&:amount).inject(&:+) || 0
  end

end
