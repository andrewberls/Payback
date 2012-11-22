class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :notif_type
      t.boolean :read, default: :false

      t.belongs_to :expense
      t.belongs_to :user_from
      t.belongs_to :user_to

      t.timestamps
    end
  end
end
