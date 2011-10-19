class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tag_type

      t.timestamps
    end
    add_index :tags, :name
    add_index :tags, :tag_type
    add_index :tags, [:name, :tag_type], :unique => true
  end
end
