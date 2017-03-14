class CreateTranslations < ActiveRecord::Migration[5.0]
    def change
        create_table :translations do |t|
            t.integer :base_id
            t.integer :result_id
            t.timestamps
        end
        add_index :translations, :base_id
        add_index :translations, :result_id
    end
end
