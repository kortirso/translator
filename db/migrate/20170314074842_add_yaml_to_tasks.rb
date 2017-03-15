class AddYamlToTasks < ActiveRecord::Migration[5.0]
    def change
        add_column :tasks, :yaml, :string
    end
end
