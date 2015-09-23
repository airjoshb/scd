class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :article, index: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
