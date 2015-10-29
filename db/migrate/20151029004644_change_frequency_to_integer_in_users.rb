class ChangeFrequencyToIntegerInUsers < ActiveRecord::Migration
  def change
    change_column :users, :frequency, 'integer USING CAST(frequency AS integer)'
  end
end
