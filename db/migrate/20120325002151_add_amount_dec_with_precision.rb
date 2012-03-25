class AddAmountDecWithPrecision < ActiveRecord::Migration
  def up
    remove_column :expenses, :amount
    add_column :expenses, :amount, :decimal, precision: 10, scale: 2
  end

  def down
    remove_column :expenses, :amount
    add_column :expenses, :amount, :integer
  end
end
