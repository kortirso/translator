class ChangeTranslationsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :translations, :direction
  end
end
