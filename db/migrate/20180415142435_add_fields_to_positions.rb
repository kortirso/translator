class AddFieldsToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :base_value, :text, null: false, default: ''
    add_column :positions, :temp_value, :text, null: false, default: ''
    add_column :positions, :translator_value, :text, null: false, default: ''
    add_column :positions, :current_value, :text, null: false, default: ''
  end
end
