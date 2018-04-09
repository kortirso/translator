class ChangeFilesInTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :file
    remove_column :tasks, :temporary_file
    remove_column :tasks, :result_file
  end
end
