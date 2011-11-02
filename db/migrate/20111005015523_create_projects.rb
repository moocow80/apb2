class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :organization_id
      t.string :title
      t.text :details
      t.text :deliverables
      t.text :steps
      t.text :meetings
      t.text :pro_requirements
      t.text :time_frame
      t.string :status

      t.timestamps
    end

    add_index :projects, :organization_id
  end

  def self.down
    drop_table :projects
  end
end
