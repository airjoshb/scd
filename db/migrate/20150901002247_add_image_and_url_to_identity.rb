class AddImageAndUrlToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :image_url, :string
    add_column :identities, :url, :string
  end
end
