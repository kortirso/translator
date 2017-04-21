class RemoveStringFromWords < ActiveRecord::Migration[5.1]
    def change
        remove_column :words, :locale
    end
end
