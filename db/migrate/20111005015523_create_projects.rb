class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :organization_id
      t.string :title
      t.decimal :savings
      t.integer :total_time
      t.text :description
      t.text :short_description
      t.text :deliverables
      t.text :steps
      t.text :meeting
      t.text :pro_requirements
      t.text :org_requirements
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
