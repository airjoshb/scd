class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :subhead
      t.text :body
      t.string :slug
      t.string :origin
      t.string :image
      t.datetime :publish_date

      t.timestamps
    end
  end
end
