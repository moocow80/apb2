class AddLogoToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :logo_file_name,    :string
    add_column :organizations, :logo_content_type, :string
    add_column :organizations, :logo_file_size,    :integer
    add_column :organizations, :logo_updated_at,   :datetime
  end
end
