class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.text :mission
      t.string :website
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
