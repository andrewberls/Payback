class Expense < ActiveRecord::Base

  #------------------------------
  # Validations
  #------------------------------
  

  #------------------------------
  # Associations
  #------------------------------
  # Users
  belongs_to :creditor, :class_name => "User"
  belongs_to :debtor,   :class_name => "User"

end
