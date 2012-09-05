class Expense < ActiveRecord::Base

  attr_accessible :title, :amount, :action, :active

  validates :amount,
    presence: true,
    numericality: true

  validates :title,
    presence: true,
    length: {maximum: 50}


  # Groups
  belongs_to :group

  # Users
  belongs_to :creditor, class_name: "User"
  belongs_to :debtor,   class_name: "User"


  def edited?
    created_at != updated_at
  end

  def cost_for(users)
    # The cost for each user, calculated based on the action type
    # Split includes current user, Payback excludes
    user_count    = (action == :split) ? users.count + 1 : users.count
    cost_per_user = amount / user_count
    cost_per_user = "%.2f" % ((cost_per_user*2.0).round / 2.0) # Round to nearest $0.50

    cost_per_user
  end

  def assign_to(*users)
    # Split and assign a debt amongst a set of selected users
    # Creates a duplicated instance to assign to each user

    users.flatten.each do |user|
      expense = self.dup
      user.add_debt(expense)
    end
  end

end
