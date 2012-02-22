class AddUniqueIndexToContributors < ActiveRecord::Migration
  def change
    add_index :contributors, [:user_id, :project_id], :unique => true
  end
end
