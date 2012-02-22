class AddAvatarToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :avatar_file_name,    :string
    add_column :user_profiles, :avatar_content_type, :string
    add_column :user_profiles, :avatar_file_size,    :integer
    add_column :user_profiles, :avatar_updated_at,   :datetime
  end
end
