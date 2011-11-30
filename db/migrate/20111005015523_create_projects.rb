class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :organization_id
      t.string :name
      t.text :details
      t.text :goals
      t.string :status
      t.string :verification_token
      t.boolean :verified, :default => false

      t.timestamps
    end

    add_index :projects, :organization_id
  end

  def self.down
    drop_table :projects
  end
end
