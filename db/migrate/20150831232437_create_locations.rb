class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state_or_province
      t.string :postal_code
      t.integer :user_id
      t.integer :article_id
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :locations, [:user_id]
    add_index :locations, [:article_id]
  end
end
