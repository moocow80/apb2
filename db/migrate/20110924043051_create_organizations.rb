class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :contact
      t.string :contact_email
      t.string :website
      t.string :phone 
      t.text :mission
      t.text :details
      t.integer :user_id
      t.string :verification_token
      t.boolean :verified, :default => false

      t.timestamps
    end

    add_index :organizations, :name, :unique => true
  end

  def self.down
    drop_table :organizations
  end
end
