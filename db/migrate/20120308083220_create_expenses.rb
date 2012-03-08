class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :amount
      t.string :title

      t.timestamps
    end
  end
end
