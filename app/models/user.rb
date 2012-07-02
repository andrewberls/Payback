class User < ActiveRecord::Base

  attr_accessible :full_name, :email, :password, :password_confirmation

  has_secure_password

  validates :full_name, 
    presence: true, 
    length: {maximum: 50}

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true, 
    format: {with: valid_email_regex},
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


  def as_json(options={})
    options[:except] = [:password_digest, :auth_token, :updated_at]
    super(options)
  end

  def first_name
    self.full_name.split(" ").first
  end

  def last_name
    self.full_name.split(" ").last
  end

  def active_credits
    credits.where(active: true)
  end

  def active_debts
    debts.where(active: true)
  end

  def credits_to(user)
    credits.where(debtor_id: user).reverse # equivalent to ordering by id desc
  end

  def debts_to(user)
    debts.where(creditor_id: user).reverse # equivalent to ordering by id desc
  end


  def add_debt(expense)
    expense.debtor = self
    self.debts << expense
  end

  def total_credit_owed
    active_credits.inject(0) { |total, exp| total + exp.amount }
  end

  def total_debt_owed
    active_debts.inject(0) { |total, exp| total + exp.amount }
  end

  def groups_with_credits
    # Groups in which this user has outstanding credits
    groups.reject { |group| group.credits_from(self).blank? }
  end

  def groups_with_debts
    # Groups in which this user has outstanding debts
    groups.reject { |group| group.debts_from(self).blank? }
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
