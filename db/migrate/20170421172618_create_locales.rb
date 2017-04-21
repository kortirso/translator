class CreateLocales < ActiveRecord::Migration[5.1]
    def change
        execute 'create extension hstore'
        create_table :locales do |t|
            t.string :code
            t.string :country_code
            t.hstore :names
            t.timestamps
        end
        add_column :words, :locale_id, :integer
        add_index :words, :locale_id
    end
end
