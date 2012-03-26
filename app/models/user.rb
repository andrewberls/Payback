class User < ActiveRecord::Base

  #------------------------------
  # Validations
  #------------------------------
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_secure_password

  validates :first_name, 
    presence: true, 
    length: {maximum: 50}

  validates :last_name, 
    presence: true, 
    length: {maximum: 50}

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true, 
    format: {with: valid_email_regex},
    uniqueness: { case_sensitive: false }

  validates :password, presence: { on: :create }, 
                       length: { minimum: 5 }, :if => :password_digest_changed?

  #------------------------------
  # Associations
  #------------------------------
  # Groups
  has_and_belongs_to_many :groups
  has_many :owned, :class_name => "Group", :foreign_key => "owner_id"

  # Expenses
  has_many :debts,   :class_name => "Expense", :foreign_key => :debtor_id
  has_many :credits, :class_name => "Expense", :foreign_key => :creditor_id


  before_save :generate_auth_token

  

  def full_name
    self.first_name + " " + self.last_name
  end

  def active_credits
    self.credits.where(active: true)
  end

  def active_debts
    self.debts.where(active: true)
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
