class AddResultToTasks < ActiveRecord::Migration[5.0]
    def change
        add_column :tasks, :result_file, :string
    end
end
