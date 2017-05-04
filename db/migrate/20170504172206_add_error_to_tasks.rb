class AddErrorToTasks < ActiveRecord::Migration[5.1]
    def change
        add_column :tasks, :error, :integer, default: nil
    end
end
