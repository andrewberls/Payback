class CreateExpensesTags < ActiveRecord::Migration
  def change
    create_table :expenses_tags, id: false do |t|
      t.integer :expense_id
      t.integer :tag_id
    end
  end
end
