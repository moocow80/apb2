class CreateTaggeds < ActiveRecord::Migration
  def change
    create_table :taggeds do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :tag_id

      t.timestamps
    end

    add_index :taggeds, [:taggable_id, :taggable_type, :tag_id], :unique => true
  end
end
