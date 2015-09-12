class AddTipsAndWhyToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :tips, :string
    add_column :articles, :why, :string
  end
end
