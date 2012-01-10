class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :status, :default => 'pending'
      t.text :reason

      t.timestamps
    end
  end
end
