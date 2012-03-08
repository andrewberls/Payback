class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :gid
      t.string :title
      t.string :password_digest

      t.timestamps
    end
  end
end
