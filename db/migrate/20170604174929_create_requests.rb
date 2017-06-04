class CreateRequests < ActiveRecord::Migration[5.1]
    def change
        create_table :requests do |t|
            t.text :body
            t.integer :user_id
            t.timestamps
        end
        add_index :requests, :user_id
    end
end
