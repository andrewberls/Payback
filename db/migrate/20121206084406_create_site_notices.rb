class CreateSiteNotices < ActiveRecord::Migration
  def change
    create_table :site_notices do |t|
      t.string :title
      t.datetime :expires_at

      t.timestamps
    end
  end
end
