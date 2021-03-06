class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.boolean :is_admin
      t.boolean :is_organization
      t.string :email_token
      t.boolean :verified, :default => false

      t.timestamps
    end

    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
    remove_index :users, :email
  end
end
