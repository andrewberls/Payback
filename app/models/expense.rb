class Expense < ActiveRecord::Base

  #------------------------------
  # Validations
  #------------------------------
  belongs_to :creditor, :class_name => "User"#, :foreign_key => :creditor_id
  belongs_to :debtor,   :class_name => "User"#, :foreign_key => :debtor_id


  #------------------------------
  # Associations
  #------------------------------


end
