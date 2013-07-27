class CreateCommunicationPreferences < ActiveRecord::Migration
  def change
    create_table :communication_preferences do |t|
      t.integer :user_id

      # Store boolean preferences as ints to work with Rails checkboxes
      t.integer :mark_off, default: 1
      t.timestamps
    end
  end
end
