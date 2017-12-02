class ChangeToFromTasks < ActiveRecord::Migration[5.1]
    def change
        change_column_default :tasks, :to, ''
    end
end
