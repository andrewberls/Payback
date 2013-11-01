class NotificationManyExpenses < ActiveRecord::Migration
  create_table :expenses_notifications, id: false do |t|
    t.integer :expense_id
    t.integer :notification_id
  end

  Notification.all.each do |n|
    n.expenses << Expense.find(n.expense_id)
  end
end
