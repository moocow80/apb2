class CreateContributeRelationships < ActiveRecord::Migration
  def self.up
    create_table :contribute_relationships do |t|
      t.integer :contributor_id
      t.integer :project_id

      t.timestamps
    end
    add_index :contribute_relationships, :contributor_id
    add_index :contribute_relationships, :project_id
    add_index :contribute_relationships, [:contributor_id, :project_id], :unique => true
  end

  def self.down
    drop_table :contribute_relationships
  end
end
