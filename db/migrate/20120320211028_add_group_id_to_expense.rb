class AddGroupIdToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :group_id, :integer
  end
end
