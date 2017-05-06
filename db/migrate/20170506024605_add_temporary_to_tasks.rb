class AddTemporaryToTasks < ActiveRecord::Migration[5.1]
    def change
        add_column :tasks, :temporary_file, :string
    end
end
