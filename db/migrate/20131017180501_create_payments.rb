class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :expense_id

      # Denormalized fields
      t.integer :creditor_id
      t.integer :debtor_id
      t.string :title
      t.decimal :amount

      t.timestamps
    end
  end
end
