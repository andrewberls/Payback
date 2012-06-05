class Expense < ActiveRecord::Base

  # TODO: fat model, skinny controller. Get on it.

  #------------------------------
  # Validations
  #------------------------------
  validates :amount, 
    presence: true,
    numericality: true

  validates :title, 
    presence: true, 
    length: {maximum: 50}


  #------------------------------
  # Associations
  #------------------------------
  # Groups
  belongs_to :group

  # Users
  belongs_to :creditor, :class_name => "User"
  belongs_to :debtor,   :class_name => "User"

  def assign_to(*users)
    # Split and assign a debt amongst a set of selected users

    users.flatten.each do |user|
      # TODO: Check if existing expense to this creditor already and combine?
      expense = self.dup # Create a new expense instance to assign to each user
      user.add_debt(expense)
    end

  end

end
