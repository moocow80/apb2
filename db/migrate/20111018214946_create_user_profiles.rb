class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :name
      t.string :phone
      t.string :current_employer
      t.string :job_title
      t.text :degrees
      t.text :experience
      t.string :website
      t.boolean :available

      t.timestamps
    end

    add_index :user_profiles, :user_id, :unique => true
    add_index :user_profiles, :name
  end
end
