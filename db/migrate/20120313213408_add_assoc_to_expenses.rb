class AddAssocToExpenses < ActiveRecord::Migration
  def change   
    add_column :expenses, :creditor_id, :integer
    add_column :expenses, :debtor_id, :integer
  end
end
