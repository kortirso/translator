class AddUniqsToWords < ActiveRecord::Migration[5.2]
  def change
    add_index :words, [:text, :locale_id], unique: true
  end
end
