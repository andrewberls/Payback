class AddNewDebtToCommunicationPreferences < ActiveRecord::Migration
  def change
    add_column :communication_preferences, :new_debt, :string
  end
end
