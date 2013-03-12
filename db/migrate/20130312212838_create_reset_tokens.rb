class CreateResetTokens < ActiveRecord::Migration
  def change
    create_table :reset_tokens do |t|
      t.string :token
      t.belongs_to :user
      t.datetime :expires_at
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
