class AddFieldsToTasks < ActiveRecord::Migration[5.0]
    def change
        add_column :tasks, :from, :string, default: '', null: false
        add_column :tasks, :to, :string, default: 'en', null: false
    end
end
