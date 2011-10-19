class CreateUserProfileTags < ActiveRecord::Migration
  def change
    create_table :user_profile_tags do |t|
      t.integer :user_profile_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :user_profile_tags, :user_profile_id
    add_index :user_profile_tags, :tag_id
    add_index :user_profile_tags, [:user_profile_id, :tag_id], :unique => true
  end
end
