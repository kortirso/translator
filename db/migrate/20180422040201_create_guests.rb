class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :remember_digest
      t.integer :user_id
      t.timestamps
    end
    add_index :guests, :user_id
    # modify users for sessions
    add_column :users, :remember_digest, :string
    # modify tasks for polymorphic
    add_column :tasks, :personable_id, :integer
    add_column :tasks, :personable_type, :string
    add_index :tasks, [:personable_type, :personable_id]
    remove_column :tasks, :user_id
  end
end
