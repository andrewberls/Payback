class Expense < ActiveRecord::Base

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

end
