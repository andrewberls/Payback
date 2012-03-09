class SplitUserName < ActiveRecord::Migration
  def up
  	remove_column :users, :name
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  end

  def down
  	remove_column :users, :first_name
  	remove_column :users, :last_name
  	add_column :users, :name, :string
  end
end
