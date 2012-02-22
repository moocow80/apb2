class AddResumeToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :resume_file_name,    :string
    add_column :user_profiles, :resume_content_type, :string
    add_column :user_profiles, :resume_file_size,    :integer
    add_column :user_profiles, :resume_updated_at,   :datetime
  end
end
