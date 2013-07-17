class InitializeUserCommunicationPreferences < ActiveRecord::Migration
  def up
    User.all.each do |user|
      CommunicationPreference.create! user: user, mark_off: "1", new_debt: "1"
    end
  end

  def down
    CommunicationPreference.delete_all
  end
end
