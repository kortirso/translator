class AddDoubleToTask < ActiveRecord::Migration[5.1]
    def change
        add_column :tasks, :double, :boolean, default: false
    end
end
