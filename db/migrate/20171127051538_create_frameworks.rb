class CreateFrameworks < ActiveRecord::Migration[5.1]
    def change
        create_table :frameworks do |t|
            t.string :name
            t.string :extension
            t.timestamps
        end
    end
end
