class RenameYamlToFile < ActiveRecord::Migration[5.0]
    def change
        rename_column :tasks, :yaml, :file
    end
end
