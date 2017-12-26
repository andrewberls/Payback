# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  gid             :string(255)
#  title           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer
#

class Group < ActiveRecord::Base

  attr_accessible :title, :password, :password_confirmation, :gid

  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User"

  has_many :debts, class_name: "Expense"
  has_many :credits, class_name: "Expense"

  has_many :invitations
  accepts_nested_attributes_for :invitations

  validates :title,
    presence: true,
    length: { maximum: 50 }

  before_create :generate_gid

  def initialize_owner(user)
    self.owner = user
    users << user
    user.owned << self
  end

  def add_user(user)
    return false if users.include?(user)
    users << user
    true
  end

  def remove_user(user)
    user.expenses(self).each do |e|
      (user.id == e.creditor_id) ? e.creditor_id = nil : e.debtor_id = nil
      e.deactivate
      e.save!
    end

    users.delete user
  end

  def peers(user)
    users - [user]
  end

  def expenses
    (debts + credits).uniq
  end

  def total_exchanged
    expenses.map(&:amount).sum.to_i
  end

  private

  # A unique external identifier used for the 'Join by ID' feature
  # Note that the external GID is distinct from the internal ID (primary key only)
  # This does nothing if the gid has been set manually
  def generate_gid
    unless self.gid.present?
      begin
        digest_string = self.id.to_s << Time.now.to_i.to_s
        self.gid      = Digest::MD5.hexdigest(digest_string)[0..5]
      end while Group.where(gid: self.gid).exists?
    end
  end

end
