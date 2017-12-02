class AddFrameworkToTasks < ActiveRecord::Migration[5.1]
    def change
        add_column :tasks, :framework_id, :integer
        add_index :tasks, :framework_id
    end
end
