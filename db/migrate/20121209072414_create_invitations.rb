class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :token
      t.belongs_to :sender
      t.belongs_to :group
      t.string :recipient_email
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
