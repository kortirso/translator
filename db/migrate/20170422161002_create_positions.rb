class CreatePositions < ActiveRecord::Migration[5.1]
    def change
        create_table :positions do |t|
            t.integer :task_id
            t.integer :translation_id
            t.timestamps
        end
        add_index :positions, :task_id
        add_index :positions, :translation_id
    end
end
