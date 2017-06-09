class AddVerifiedToTranslations < ActiveRecord::Migration[5.1]
    def change
        add_column :translations, :verified, :boolean, default: false
    end
end
