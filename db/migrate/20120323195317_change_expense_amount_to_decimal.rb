class ChangeExpenseAmountToDecimal < ActiveRecord::Migration
  def change
    remove_column :expenses, :amount
    add_column :expenses, :amount, :decimal
  end
end
