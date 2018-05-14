class AddFieldToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :phrases_value, :text, null: false, default: ''
  end
end
