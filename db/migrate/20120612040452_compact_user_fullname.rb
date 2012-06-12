class CompactUserFullname < ActiveRecord::Migration
  def up
    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :full_name, :string
  end

  def down
    remove_column :users, :full_name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
