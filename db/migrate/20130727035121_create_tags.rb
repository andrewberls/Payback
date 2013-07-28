class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.timestamps
    end

    # Seed initial tags in prod
    Tag::CORE_TYPES.each do |type|
      Tag.create!(title: type)
    end
  end
end
