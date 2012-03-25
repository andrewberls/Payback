class AddActiveToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :active, :boolean, default: true
  end
end
