class ChangePositionsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :positions, :translation_id
  end
end
