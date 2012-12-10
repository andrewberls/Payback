class Group < ActiveRecord::Base

  attr_accessible :title, :password, :password_confirmation, :gid

  has_secure_password

  validates :title,
    presence: true,
    length: { maximum: 50 }

  validates :password, presence: { on: :create },
                       length: { minimum: 5 }, :if => :password_digest_changed?

  before_create :generate_gid

  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User"

  has_many :debts, class_name: "Expense"
  has_many :credits, class_name: "Expense"

  has_many :invitations
  accepts_nested_attributes_for :invitations

  def as_json(options={})
    options[:except] ||= [:password_digest, :id]
    super(options)
  end

  def initialize_owner(user)
    owner = user
    users << user
    user.owned << self
  end

  def add_user(user)
    users << user
  end

  def remove_user(user)
    user.expenses(self).map(&:destroy)
    users.delete user
  end

  def expenses
    (debts + credits).uniq
  end

  def active_credits_for(user)
    credits.where(creditor_id: user, active: true).order('id DESC')
  end

  def active_debts_for(user)
    debts.where(debtor_id: user, active: true).order('id DESC')
  end

  def active_credit_users_for(user)
    # All users from a specific group with outstanding credits from a user
    (users - [user]).reject { |u| user.active_credits_to(u).blank? }
  end

  def active_debt_users_for(user)
    # All users from a specific group with outstanding credits to a user
    (users - [user]).reject { |u| user.active_debts_to(u).blank? }
  end

  private

  def generate_gid
    # A unique external identifier used for the 'Join by ID' feature
    # Note that the external GID is distinct from the internal ID (primary key only)
    # This does nothing if the gid has been set manually

    unless self.gid.present?
      # Combine auto id + timestamp for uniqueness
      digest_string = self.id.to_s << Time.now.to_i.to_s
      self.gid = Digest::MD5.hexdigest(digest_string)[0..5]
    end
  end

end
