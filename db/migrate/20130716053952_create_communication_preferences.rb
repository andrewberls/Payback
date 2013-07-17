class CreateCommunicationPreferences < ActiveRecord::Migration
  def change
    create_table :communication_preferences do |t|
      t.integer :user_id

      # Store boolean preferences as strings to work with convoluted Rails checkboxes
      # i.e., "1" or "0"
      t.string :mark_off, default: "1"
      t.timestamps
    end
  end
end
