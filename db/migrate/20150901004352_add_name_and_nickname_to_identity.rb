class AddNameAndNicknameToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :name, :string
    add_column :identities, :nickname, :string
  end
end
