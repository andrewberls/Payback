class CreateExpensesPayments < ActiveRecord::Migration
  def change
    create_table :expenses_payments, id: false do |t|
      t.integer :expense_id
      t.integer :payment_id
    end
  end
end
