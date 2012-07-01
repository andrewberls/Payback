class AddActionToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :action, :string
  end
end
