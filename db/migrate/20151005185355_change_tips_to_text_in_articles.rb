class ChangeTipsToTextInArticles < ActiveRecord::Migration
  def change
    change_column :articles, :tips, :text, :limit => nil
    change_column :articles, :why, :text, :limit => nil
  end
end
