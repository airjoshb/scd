class ChangeImageUrlToAvatarUrlInIdentity < ActiveRecord::Migration
  def change
    rename_column :identities, :image_url, :avatar_url
  end
end
