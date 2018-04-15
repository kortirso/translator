class CreatePhrases < ActiveRecord::Migration[5.2]
  def change
    create_table :phrases do |t|
      t.integer :position_id, null: false
      t.integer :word_id, null: false
      t.text :current_value
      t.timestamps
    end
    add_index :phrases, :position_id
    add_index :phrases, :word_id
  end
end
