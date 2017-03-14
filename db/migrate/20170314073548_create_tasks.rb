class CreateTasks < ActiveRecord::Migration[5.0]
    def change
        create_table :tasks do |t|
            t.string :uid, default: '', null: false
            t.string :status, default: 'active', null: false
            t.timestamps
        end
    end
end
