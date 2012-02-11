class AddImageToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :image_file_name,    :string
    add_column :user_profiles, :image_content_type, :string
    add_column :user_profiles, :image_file_size,    :integer
    add_column :user_profiles, :image_updated_at,   :datetime
  end
end
