class Group < ActiveRecord::Base

  attr_accessible :title, :password, :password_confirmation, :gid

  has_secure_password

  validates :title,
    presence: true,
    length: {maximum: 50}

  validates :password, presence: { on: :create },
                       length: { minimum: 5 }, :if => :password_digest_changed?

  before_create :generate_gid

  # validates_uniqueness_of :gid


  # Users
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User"

  # Expenses
  has_many :debts, class_name: "Expense"
  has_many :credits, class_name: "Expense"


  def as_json(options={})
    options[:except] ||= [:password_digest, :id]
    super(options)
  end

  def initialize_owner(user)
    owner = user
    users << user
    user.owned << self # user.groups automatically covered
  end

  def add_user(user)
    users << user
  end

  def remove_user(user)
    expenses = (user.credits + user.debts).select { |e| e.group == self }
    expenses.each { |e| e.destroy }
    users.delete user
  end

  def expenses
    debts + credits
  end

  def credits_from(user)
    credits.where(creditor_id: user)
  end

  def debts_from(user)
    debts.where(debtor_id: user)
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
