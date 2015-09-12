class ChangeAvatarUrlToAvatarInIdentity < ActiveRecord::Migration
  def change
    rename_column :identities, :avatar_url, :avatar
  end
end
