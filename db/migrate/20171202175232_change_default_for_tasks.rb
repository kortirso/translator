class ChangeDefaultForTasks < ActiveRecord::Migration[5.1]
    def change
        change_column_default :tasks, :status, 'verification'
    end
end
