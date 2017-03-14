class CreateWords < ActiveRecord::Migration[5.0]
    def change
        create_table :words do |t|
            t.string :text
            t.string :locale
            t.timestamps
        end
    end
end
