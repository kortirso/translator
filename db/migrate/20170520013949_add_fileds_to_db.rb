class AddFiledsToDb < ActiveRecord::Migration[5.1]
    def change
        add_column :translations, :direction, :string, null: false, default: ''
    end
end
